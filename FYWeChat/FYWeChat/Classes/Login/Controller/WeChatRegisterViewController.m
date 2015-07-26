//
//  WeChatRegisterViewController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/20.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatRegisterViewController.h"
#import "AppDelegate.h"
#import "UITextField+WF.h"

@interface WeChatRegisterViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Right;
@property (weak, nonatomic) IBOutlet UIButton *Register;

@end

@implementation WeChatRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    判断当前设备的类型， 改变左右两边的间距
    if ([UIDevice currentDevice])
    {
        self.Left.constant=10;
        self.Right.constant=10;
    }
  //    设置textfeild的背景图片
    self.PhoneNumber.background=[UIImage stretchedImageWithName:@"operationbox_text"];
    self.Pwd.background=[UIImage stretchedImageWithName:@"operationbox_text"];
    [self.Register setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
}

- (IBAction)Register:(id)sender
{
    //    点击注册按钮的时候隐藏键盘
    [self.view endEditing:YES];
    
//    判断用户输入的是否是手机号码
    if (![self.PhoneNumber isTelphoneNum]) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
    }
//    1.把注册的数据保存到单例里面去
    WeChatUser *userInfo=[WeChatUser sharedWeChatUser];
    userInfo.registerUsername=self.PhoneNumber.text;
    userInfo.registerPwd=self.Pwd.text;
//    2.调用注册方法
    __weak typeof(self)selfVC=self;
    WeChatXMPPTool *xmppTool=[WeChatXMPPTool sharedWeChatXMPPTool];
    xmppTool.isRegisterOperation=YES;
    [MBProgressHUD showMessage:@"正在注册，请稍后" toView:self.view];
    [xmppTool register:^(XMPPResaultType type) {
        [selfVC handleResaultType:type];
    } ];
//    
}
//处理请求结果
-(void)handleResaultType:(XMPPResaultType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResaultTypeRegisterFailure:
                [MBProgressHUD showError:@"注册失败，用户名重复" toView:self.view];
                break;
            case XMPPResaultTypeRegisterSuccess:
                [MBProgressHUD showSuccess:@"注册成功" toView:self.view];
//                回到上一个页面
                [self dismissViewControllerAnimated:YES completion:nil];
                
                if ([self.delegate respondsToSelector:@selector(registerViewControllerdidFinish)]) {
                    [self.delegate registerViewControllerdidFinish];
                }
                break;
            default:
                break;
        }
    });
}
- (IBAction)Back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
