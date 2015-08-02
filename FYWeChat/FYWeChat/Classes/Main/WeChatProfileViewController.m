//
//  WeChatProfileViewController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/26.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatProfileViewController.h"
#import "WeChatUser.h"
#import "XMPPvCardTemp.h"
#import "WeChatEditProfileViewController.h"


@interface WeChatProfileViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,EditProfileViewControllerdelegate>
//头像
@property (weak, nonatomic) IBOutlet UIImageView *IconView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *NickName;
//微信号
@property (weak, nonatomic) IBOutlet UILabel *WeiXinNum;
//公司
@property (weak, nonatomic) IBOutlet UILabel *Company;
//部门
@property (weak, nonatomic) IBOutlet UILabel *Depart;
//职位
@property (weak, nonatomic) IBOutlet UILabel *ZhiWei;
//电话
@property (weak, nonatomic) IBOutlet UILabel *Phone;
//邮件
@property (weak, nonatomic) IBOutlet UILabel *Email;

@end

@implementation WeChatProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    加载电子名片信息
    [self loadVCard];
   
}
//加载电子名片信息
-(void)loadVCard
{
    //    Xmpp框架提供了一个方法，可以直接获取个人信息  使用电子名片模块
    XMPPvCardTemp *myCard=[WeChatXMPPTool sharedWeChatXMPPTool].vCard.myvCardTemp;
    //    设置头像
    if (myCard.photo) {
        self.IconView.image=[UIImage imageWithData:myCard.photo];
    }
    //   设置昵称
    self.NickName.text=myCard.nickname;
    //    设置微信号
    NSString *user=[WeChatUser sharedWeChatUser].username;
    self.WeiXinNum.text=[NSString stringWithFormat:@"%@",user];
    
    //    公司
    self.Company.text=myCard.orgName;
    //    部门
    if (myCard.orgUnits.count>0) {
        self.Company.text=myCard.orgUnits[0];
    }
    //    职位
    self.ZhiWei.text=myCard.title;
    //    电话
#warning myCard.telecomsAddresses  这个get方法没有对电子名片的xml数据进行解析
    //    使用note字段充当电话
    self.Phone.text=myCard.note;
    //    邮件
    //    用mailer充当邮件
    self.Email.text=myCard.mailer;
    
//    邮件的解析
    self.Email.text=myCard.emailAddresses;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    获取cell.tag
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSInteger tag=cell.tag;
    if (tag==2)
    {
//        不作任何操作
        FYLog(@"不作任何操作");
        return;
    }
    else if (tag==0)
    {
//        上传头像
        FYLog(@"上传头像");
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
        [sheet showInView:self.view];
    }
    else
    {
//        跳转到下一个控制器
        FYLog(@"跳转到下一个控制器");
        [self performSegueWithIdentifier:@"EditVCardSegue" sender:cell];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    获取编辑个人信息的控制器
    id desvc=segue.destinationViewController;
    if ([desvc isKindOfClass:[WeChatEditProfileViewController class]]) {
        WeChatEditProfileViewController *editVC=desvc;
        editVC.profileCell=sender;
        editVC.delegate=self;
    }
}
#pragma mark ----UIActionSheetdelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagepikc=[[UIImagePickerController alloc]init];
    imagepikc.delegate=self;
    imagepikc.allowsEditing=YES;
    
    if (buttonIndex==0) {
        FYLog(@"拍照");
        imagepikc.sourceType=UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex==1)
    {
        imagepikc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        FYLog(@"从相册选取");
    }
//    显示图片选择器页面
    [self presentViewController:imagepikc animated:YES completion:nil];
}
#pragma mark ---UIImagePickerControllerdelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    FYLog(@"%@",info);
//    获取图片
    UIImage *image=info[UIImagePickerControllerEditedImage];
//    设置图片
    self.IconView.image=image;
//    返回
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)editProfileViewControllerDidSava
{
//    保存
    //    更新到服务器
    
    //    获取当前的电子名片信息
    XMPPvCardTemp *vcard=[WeChatXMPPTool sharedWeChatXMPPTool].vCard.myvCardTemp;
//    重新更新所有的属性值
    
    //    更新到服务器
       //    更换头像
    if (vcard.photo) {
        self.IconView.image=[UIImage imageWithData:vcard.photo];
    }
//    昵称
    vcard.nickname=self.NickName.text;
//    公司
    vcard.orgName=self.Company.text;
//    职位
    vcard.title=self.ZhiWei.text;
//    电话
    vcard.note=self.Phone.text;
//    部门
    if (self.Depart.text.length>0) {
        vcard.orgUnits=@[self.Depart.text];
    }
//    邮件
    vcard.mailer=self.Email.text;

    //    这个方法会实现数据上传到服务器，无需程序员自己操作
    [[WeChatXMPPTool sharedWeChatXMPPTool].vCard updateMyvCardTemp:vcard];
}
@end
