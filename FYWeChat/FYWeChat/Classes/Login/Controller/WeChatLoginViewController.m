//
//  WeChatLoginViewController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/19.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatLoginViewController.h"
#import "AppDelegate.h"
#import "WeChatRegisterViewController.h"
#import "WeChatNavigationController.h"
@interface WeChatLoginViewController ()<WeChatRegisterViewControllerDelegate>

@end

@implementation WeChatLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    从沙盒中获取用户名
    self.userLable.text=[WeChatUser sharedWeChatUser].username;
    self.userLable.textAlignment=NSTextAlignmentCenter;
    
    self.Pwd.background=[UIImage stretchedImageWithName:@"operationbox_text"];
    [self.Pwd addLeftViewWithImage:@"Card_Lock"];
    
//    UIImageView *lockimage=[[UIImageView alloc]init];
//    lockimage.bounds=CGRectMake(5, 5, 20, 20);
//    lockimage.image=[UIImage imageNamed:@"Card_Lock"];
//    self.Pwd.leftViewMode=UITextFieldViewModeAlways;
//    self.Pwd.leftView=lockimage;
}
//登陆
- (IBAction)Login:(id)sender
{
//  保存数据到单例里面去
    WeChatUser *userInfo=[WeChatUser sharedWeChatUser];
    userInfo.username=self.userLable.text;
    userInfo.pwd=self.Pwd.text;
    [super login];
}

//忘记密码
- (IBAction)ForgetPwd:(id)sender
{
    
}
//注册
- (IBAction)MyRegister:(id)sender
{
    NSLog(@"您好，您点击了注册按钮");
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    获取注册控制器
    id destVC=[segue destinationViewController];
//    判断destVC是不是注册控制器
    if ([destVC isKindOfClass:[WeChatNavigationController class]]) {
//
        WeChatNavigationController *navc=destVC;
//        获取跟控制器
        WeChatRegisterViewController  *registerVC=(WeChatRegisterViewController *)navc.topViewController;
        //    设置注册控制器的代理
        registerVC.delegate=self;
    }
}
#pragma mark --WeChatRegisterViewControllerDelegate
-(void)registerViewControllerdidFinish
{
//    完成注册 userlabel显示已注册的用户名
    self.userLable.text=[WeChatUser sharedWeChatUser].registerUsername;
}
@end
