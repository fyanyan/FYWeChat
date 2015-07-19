//
//  WeChatUser.h
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/19.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@interface WeChatUser : NSObject
singleton_interface(WeChatUser)

@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *pwd;
//登录状态 YES 表示登录  NO表示注销
@property(nonatomic,assign)BOOL loginStatus;

//保存用户数据到沙盒
-(void)saveUserInfoToSanBox;
//从沙盒获取用户数据
-(void)loadUserInfoSandBox;
@end
