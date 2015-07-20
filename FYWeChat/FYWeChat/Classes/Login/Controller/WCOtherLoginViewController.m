//
//  WCOtherLoginViewController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/19.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WCOtherLoginViewController.h"
#import "AppDelegate.h"


@interface WCOtherLoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RightConstraint;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)LoginAction:(id)sender;

@end

@implementation WCOtherLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    判断当前设备的类型， 改变左右两边的间距
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        self.LeftConstraint.constant=10;
        self.RightConstraint.constant=10;
    }
//    设置textfeild的背景图片
    self.userField.background=[UIImage stretchedImageWithName: @"operationbox_text"];
    self.pwdField.background=[UIImage stretchedImageWithName:@"operationbox_text"];
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
}


//登陆操作
- (IBAction)LoginAction:(id)sender
{
    /*
     官方登陆操作的实现
     1.把用户名和密码保存到WeChatUser的单例里面去
     2.调用AppDelegate的connect方法 连接服务器
     */
//    隐藏键盘
    [self.view endEditing:YES];
   
    WeChatUser *userInfo=[WeChatUser sharedWeChatUser];
    userInfo.username=self.userField.text;
    userInfo.pwd=self.pwdField.text;
    
    [super login];
    
//    NSString *username=self.userField.text;
//    NSString *pwd=self.pwdField.text;
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    [defaults setObject:username forKey:@"username"];
//    [defaults setObject:pwd forKey:@"password"];
//    [defaults synchronize];
}



-(void)dealloc
{
    FYLog(@"%s",__func__);
}
- (IBAction)Back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
