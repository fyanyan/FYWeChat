//
//  WeViewController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/30.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeViewController.h"
#import "WeChatInPutView.h"
@interface WeViewController ()<NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    NSFetchedResultsController *_resultController;
}
@property(strong,nonatomic)UITableView *tableview;
@property(strong,nonatomic)NSLayoutConstraint *inputViewContraints;//inputview底部的约束
@end

@implementation WeViewController

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
    
    self.inputViewContraints.constant=kbHeight;
    [self scrollToBottom];
}
//隐藏键盘
-(void)keyboardWillHide:(NSNotification *)noti
{
    self.inputViewContraints.constant=0;
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
    self.inputViewContraints=tableVConstraint.lastObject;
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
//    显示聊天消息
    if ([msg.outgoing boolValue])
    {
//        自己发的
        cell.textLabel.text=[NSString stringWithFormat:@"me   %@",msg.body];
    }
    else {
//       别人发的
        cell.textLabel.text=[NSString stringWithFormat:@"other    %@",msg.body];
    }
    return cell;
}

//textviewdelegate 的代理方法
-(void)textViewDidChange:(UITextView *)textView
{
    FYLog(@"%@",textView.text);
    
//    换行就等于点击了发送
    if ([textView.text rangeOfString:@"\n"].length !=0) {
        FYLog(@"发送数据");
        [self sendMessageWithText:textView.text];
        textView.text=nil;
    }
}
//发送聊天消息
-(void)sendMessageWithText:(NSString *)text
{

    XMPPMessage *message=[XMPPMessage messageWithType:@"chat" to:self.friendJID];
//    设置内容
    [message addBody:text];
        FYLog(@"%@",message);
    [[WeChatXMPPTool sharedWeChatXMPPTool].xmppStream sendElement:message];
}

//
-(void)scrollToBottom
{
    NSInteger lastRow=_resultController.fetchedObjects.count-1;
    NSIndexPath *lastpath=[NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableview scrollToRowAtIndexPath:lastpath
                          atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
@end
