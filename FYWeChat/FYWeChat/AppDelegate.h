//
//  AppDelegate.h
//  FYWeChat
//
//  Created by fengyan on 15/7/17.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeChatNavigationController.h"

typedef enum
{
    XMPPResaultTypeLoginSuccess,//登陆成功
    XMPPResaultTypeLoginFailure //登陆失败
}XMPPResaultType;
typedef  void (^XMPPResaultBlock)(XMPPResaultType type);//Xmpp请求结果的block
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//用户登陆
-(void)login:(XMPPResaultBlock)resaultBlock;
//用户退出登录
-(void)logout;
@end

