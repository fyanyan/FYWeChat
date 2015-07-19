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
     1.把用户名和密码保存到应用程序沙盒里
     2.调用AppDelegate的connect方法 连接服务器
     */
//    隐藏键盘
    [self.view endEditing:YES];
    NSString *username=self.userField.text;
    NSString *pwd=self.pwdField.text;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:@"username"];
    [defaults setObject:pwd forKey:@"password"];
    [defaults synchronize];
//    [MBProgressHUD showMessage:@"正在登录中"];
    [MBProgressHUD showMessage:@"正在登录中" toView:self.view];
    
    __weak  typeof(self) selfVC=self;
    AppDelegate *app=[UIApplication sharedApplication].delegate ;
    [app login:^(XMPPResaultType type)
    {
        [selfVC handleResaultType:type];
    }];
}

-(void)handleResaultType:(XMPPResaultType)type
{
//    主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (type)
        {
            case XMPPResaultTypeLoginFailure:
            {
                FYLog(@"登陆失败");
                [MBProgressHUD showError:@"用户名或者密码不正确" toView:self.view];
            }
                break;
                
            case XMPPResaultTypeLoginSuccess:
                FYLog(@"登陆成功");
                [self EnterMainPage];
                break;
                
            default:
                break;
        }
    });
}
-(void)EnterMainPage
{
//    如果使用模态跳转页面 ，那就一定要调用dismissViewControllerAnimated这个方法，否则会出现内存问题
//    隐藏模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
//    登陆成功 跳转到主界面、
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController=storyboard.instantiateInitialViewController;
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
