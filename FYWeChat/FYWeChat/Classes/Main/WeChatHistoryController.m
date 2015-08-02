//
//  WeChatHistoryController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/8/2.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatHistoryController.h"

@interface WeChatHistoryController ()

//活动指示器
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Indicator;

@end

@implementation WeChatHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//  坚挺登录状态的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange:) name:WeChatLoginStatusChangeNotification object:nil];
}

-(void)loginStatusChange:(NSNotification *)notification
{
    FYLog(@"%@",notification.userInfo);
//    通知在子线程调用  刷新UI是在主线程刷新的
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //    获取登录状态
        int status=[notification.userInfo[@"loginStatus"] intValue];
        switch (status) {
                //            正在连接
            case XMPPResaultTypeConnecting:
                [self.Indicator startAnimating];
                break;
                //            连接失败
            case XMPPResaultTypeNetError:
                [self.Indicator stopAnimating];
                break;
                //            登陆成功
            case XMPPResaultTypeRegisterSuccess:
                [self.Indicator stopAnimating];
                break;
                //            登录失败
            case XMPPResaultTypeRegisterFailure:
                [self.Indicator stopAnimating];
                break;
            default:
                break;
        }
    });
    
}
@end
