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


extern NSString *const WeChatLoginStatusChangeNotification;

typedef enum
{
    XMPPResaultTypeConnecting,//连接中
    XMPPResaultTypeLoginSuccess,//登陆成功
    XMPPResaultTypeLoginFailure, //登陆失败
    XMPPResaultTypeRegisterSuccess,//注册成功
    XMPPResaultTypeRegisterFailure,//注册失败
    XMPPResaultTypeNetError
}XMPPResaultType;
typedef  void (^XMPPResaultBlock)(XMPPResaultType type);//Xmpp请求结果的block


@interface WeChatXMPPTool : NSObject

singleton_interface(WeChatXMPPTool)

@property(strong,nonatomic,readonly)XMPPvCardTempModule *vCard;//电子名片
@property(strong,nonatomic,readonly)XMPPRosterCoreDataStorage *rosterStorage;//花名册的数据存储
@property(strong,nonatomic,readonly)XMPPRoster *roster;//花名册模块

@property(strong,nonatomic,readonly)XMPPStream *xmppStream;

@property(strong,nonatomic,readonly)XMPPMessageArchivingCoreDataStorage *messageStorage;

//注册的标识， YES表示注册  NO表示登录
@property(assign,nonatomic)BOOL isRegisterOperation;

//用户登陆
-(void)login:(XMPPResaultBlock)resaultBlock;
//用户退出登录
-(void)logout;
//用户注册
-(void)register:(XMPPResaultBlock)resaultBlock;


@end
