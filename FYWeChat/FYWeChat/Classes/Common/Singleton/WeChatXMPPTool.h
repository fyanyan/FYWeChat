//
//  WeChatXMPPTool.h
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/25.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"

typedef enum
{
    XMPPResaultTypeLoginSuccess,//登陆成功
    XMPPResaultTypeLoginFailure, //登陆失败
    XMPPResaultTypeRegisterSuccess,//注册成功
    XMPPResaultTypeRegisterFailure//注册失败
}XMPPResaultType;
typedef  void (^XMPPResaultBlock)(XMPPResaultType type);//Xmpp请求结果的block


@interface WeChatXMPPTool : NSObject

singleton_interface(WeChatXMPPTool)

@property(strong,nonatomic)XMPPvCardTempModule *vCard;//电子名片
@property(strong,nonatomic)XMPPRosterCoreDataStorage *rosterStorage;//花名册的数据存储

//注册的标识， YES表示注册  NO表示登录
@property(assign,nonatomic)BOOL isRegisterOperation;

//用户登陆
-(void)login:(XMPPResaultBlock)resaultBlock;
//用户退出登录
-(void)logout;
//用户注册
-(void)register:(XMPPResaultBlock)resaultBlock;


@end
