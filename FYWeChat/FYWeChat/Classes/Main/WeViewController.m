//
//  WeViewController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/30.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeViewController.h"
#import "WeChatInPutView.h"
#import "HttpTool.h"

#import "UIImageView+WebCache.h"



@interface WeViewController ()<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSFetchedResultsController *_resultController;
}

@property(strong,nonatomic)UITableView *tableview;
@property(strong,nonatomic)NSLayoutConstraint *inputViewBottomContraints;//inputview底部的约束

@property(strong,nonatomic)NSLayoutConstraint *inputViewHeightContraints;//inputview高度的约束

//HTTP 工具类
@property(strong,nonatomic)HttpTool *httptool;

@end

@implementation WeViewController

-(HttpTool *)httptool
{
    if (_httptool==nil) {
        _httptool=[[HttpTool alloc]init];
    }
    return _httptool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SetUpView];
    
//    坚挺键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self loadMessage];
    
}
//显示键盘
-(void)keyboardWillShow:(NSNotification *)noti
{
//    获取键盘的高度
    CGRect kbEndFrame=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight=kbEndFrame.size.height;
    //    如果是iOS7以下的，当屏幕是横屏的时候，键盘的高度是size.width
    if ([[UIDevice currentDevice].systemVersion doubleValue]<8.0 && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        kbHeight=kbEndFrame.size.width;
    }
    
    self.inputViewBottomContraints.constant=kbHeight;
    [self scrollToBottom];
}
//隐藏键盘
-(void)keyboardWillHide:(NSNotification *)noti
{
    self.inputViewBottomContraints.constant=0;
}



-(void)SetUpView
{
    //    通过代码的方式实现自动布局 VFL语言
//    创建一个tableview 显示聊天内容
    UITableView *tableview=[[UITableView alloc]init];
    tableview.delegate=self;
    tableview.dataSource=self;
//    设置自动布局的时候 要将下面的属性设置为NO
    tableview.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:tableview];
    self.tableview=tableview;
//    创建输入框View
    WeChatInPutView *inputview=[WeChatInPutView inputView];
    //    设置自动布局的时候 要将下面的属性设置为NO
    inputview.translatesAutoresizingMaskIntoConstraints=NO;
    inputview.Text.delegate=self;
   
    
//    添加按钮的事件
    [inputview.AddBtn addTarget:self action:@selector(abbBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
     [self.view addSubview:inputview];
    
//    自动布局
//    水平方向的约束
    NSDictionary *views=@{@"tableview":tableview,
                          @"inputview":inputview
                          };
    
//   tablewview 的水平约束
  NSArray *tableHConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableHConstraint];
    
    NSArray *inputHContraint=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputview]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputHContraint];
//    垂直方向的约束
    NSArray *tableVConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableview]-0-[inputview(50)]-0-|" options:0 metrics:nil views:views];
    
//    添加inputview的高度约束
    self.inputViewHeightContraints=tableVConstraint[2];
    
    self.inputViewBottomContraints=tableVConstraint.lastObject;
    [self.view addConstraints:tableVConstraint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadMessage
{
//    上下文
    NSManagedObjectContext *context=[WeChatXMPPTool sharedWeChatXMPPTool].messageStorage.mainThreadManagedObjectContext;
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
//    设置过滤
    
//    1.当前登录用户的JID  2.好友的JID
    NSString *jid = [WeChatUser sharedWeChatUser].JID;
     NSString *friendJID=self.friendJID.bare;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr=%@",jid,friendJID];
    request.predicate = pre;
//    设置排序  时间升序
    NSSortDescriptor *time=[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors=@[time];
//    查询
    _resultController=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultController.delegate=self;
    NSError *error=nil;
    [_resultController performFetch:&error];
    

}
#pragma mark --当数据的内容发生变化后，会调用这个方法(当好友发生变化时，实时刷新好友列表)
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"数据发生改变");
    [self.tableview reloadData];
    [self scrollToBottom];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultController.fetchedObjects.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
//    获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *msg=_resultController.fetchedObjects[indexPath.row];
    
//    判断是图片消息还是纯文本消息
    NSString *type=[msg.message attributeStringValueForName:@"bodyType"];
    if ([type isEqualToString:@"image"]) {
//        下载并显示图片
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:msg.body] placeholderImage:[UIImage imageNamed:@"DefaultProfileHead_qq.png"]];
        cell.textLabel.text=nil;
    }else if([type isEqualToString:@"text"])
    {
            cell.textLabel.text=[NSString stringWithFormat:@"other    %@",msg.body];
        cell.imageView.image=nil;
    }
    

    return cell;
}

//textviewdelegate 的代理方法
-(void)textViewDidChange:(UITextView *)textView
{
//    获取contentsize
    CGSize size=textView.contentSize;
//    FYLog(@"__________%f ",size.height);
    CGFloat contentHeight=size.height;
    
//    高度大于33  超过一行的高度  小于68 高度是在三行以内的
    if (contentHeight>33 && contentHeight<68 ) {
        self.inputViewHeightContraints.constant = contentHeight+18;
    }
    
    
    FYLog(@"%@",textView.text);
    
//    换行就等于点击了发送
    if ([textView.text rangeOfString:@"\n"].length !=0) {
        FYLog(@"发送数据");
        
//        去除换行字符
        textView.text =[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        text 表示发送纯文本消息  image 图片消息
        [self sendMessageWithText:textView.text bodyType:@"text"];
        textView.text=nil;
        self.inputViewHeightContraints.constant=50;
    }
}
//发送聊天消息
-(void)sendMessageWithText:(NSString *)text bodyType:(NSString *)bodytype
{

    XMPPMessage *message=[XMPPMessage messageWithType:@"chat" to:self.friendJID];
    [message addAttributeWithName:@"bodyType" stringValue:bodytype];
    
//    设置内容
    [message addBody:text];
        FYLog(@"%@",message);
    [[WeChatXMPPTool sharedWeChatXMPPTool].xmppStream sendElement:message];
}

//
-(void)scrollToBottom
{
    NSInteger lastRow=_resultController.fetchedObjects.count-1;
    
    if (lastRow<0) {//如果行数小于0，不能滚动
        return;
    }
    
    NSIndexPath *lastpath=[NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableview scrollToRowAtIndexPath:lastpath
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//按钮的事件
-(void)abbBtnClick
{
    UIImagePickerController *imagepicker=[[UIImagePickerController alloc]init];
    imagepicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imagepicker.delegate=self;
    [self presentViewController:imagepicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    获取图片
    UIImage *image=info[UIImagePickerControllerOriginalImage];
    NSData *imageData=[NSData data];
    imageData=UIImageJPEGRepresentation(image, 0.5);
    
//    把图片发送到文件服务器
//   HTTP  POST  PUT
//    PUT实现文件的上传比较简洁  比POST快
//    PUT文件的上传路径就是下载路径
//    文件的上传路径 http://localhost:/8080/imfileserver/Upload/Image/+"图片文件名"【程序员自己确定】
    
//    使用PUT上传文件的步骤
//    1.获取文件名  用户户名+时间
    NSString *user=[WeChatUser sharedWeChatUser].username;
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    dateformat.dateFormat=@"yyyyMMddHHmmss";
    NSString *timer=[dateformat stringFromDate:[NSDate date]];
    NSString *filename=[user stringByAppendingString:timer];
    
//    2.拼接上传路径
    NSString *uploadurl=[@"http://localhost:8080/imfileserver/Upload/Image/" stringByAppendingString:filename];
    NSLog(@"%@",uploadurl);
//    3.使用HTTP协议上传文件
    [self.httptool uploadData:imageData url:[NSURL URLWithString:uploadurl] progressBlock:^(CGFloat progress) {
        NSLog(@"%f",progress);
    } completion:^(NSError *error) {
        if (!error) {
            NSLog(@"上传成功");
            [self sendMessageWithText:uploadurl bodyType:@"image"];
        }
        else
        {
            NSLog(@"%@",error);
        }
    }];
    
//    图片发送成功，把图片的URL发送到openfire的服务器
}
@end
