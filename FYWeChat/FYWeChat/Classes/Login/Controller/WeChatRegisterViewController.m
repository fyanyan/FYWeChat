//
//  WeChatRegisterViewController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/20.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatRegisterViewController.h"
#import "AppDelegate.h"

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
//    1.把注册的数据保存到单例里面去
    WeChatUser *userInfo=[WeChatUser sharedWeChatUser];
    userInfo.registerUsername=self.PhoneNumber.text;
    userInfo.registerPwd=self.Pwd.text;
//    2.调用AppleDelegate的注册方法
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    app.isRegisterOperation=YES;
    [app register:^(XMPPResaultType type) {
        
    } ];
//    
}

- (IBAction)Back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
