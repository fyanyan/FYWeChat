//
//  WeChatBaseViewController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/20.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatBaseViewController.h"
#import "AppDelegate.h"
@interface WeChatBaseViewController ()

@end

@implementation WeChatBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)login
{
    /*
     官方登陆操作的实现
     1.把用户名和密码保存到WeChatUser的单例里面去
     2.调用AppDelegate的connect方法 连接服务器
     */
    //    隐藏键盘
    [self.view endEditing:YES];
    
    //    WeChatUser *userInfo=[WeChatUser sharedWeChatUser];
    //    userInfo.username=self.userField.text;
    //    userInfo.pwd=self.pwdField.text;
    
    
    //    NSString *username=self.userField.text;
    //    NSString *pwd=self.pwdField.text;
    //    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //    [defaults setObject:username forKey:@"username"];
    //    [defaults setObject:pwd forKey:@"password"];
    //    [defaults synchronize];
    
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
    //    更改用户的登录状态为YES
    [WeChatUser sharedWeChatUser].loginStatus=YES;
    //    将用户的登录成功数据保存到沙盒
    WeChatUser *userInfo=[WeChatUser sharedWeChatUser];
    [userInfo saveUserInfoToSanBox];
    //    如果使用模态跳转页面 ，那就一定要调用dismissViewControllerAnimated这个方法，否则会出现内存问题
    //    隐藏模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    //    登陆成功 跳转到主界面、
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController=storyboard.instantiateInitialViewController;
}


@end
