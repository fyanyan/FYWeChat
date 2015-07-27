//
//  WeChatUser.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/19.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatUser.h"

#define userKey @"username"
#define UserPwdKey  @"pwd"
#define LoginStatus @"loginstatus"

@implementation WeChatUser
singleton_implementation(WeChatUser)

-(void)saveUserInfoToSanBox
{
    NSUserDefaults *sand=[NSUserDefaults standardUserDefaults];
    [sand setObject:self.username forKey:userKey];
    [sand setObject:self.pwd forKey:UserPwdKey];
    [sand setBool:self.loginStatus forKey:LoginStatus];
    [sand synchronize];
}

-(void)loadUserInfoSandBox
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.username=[defaults objectForKey:userKey];
    self.pwd=[defaults objectForKey:UserPwdKey];
    self.loginStatus=[defaults boolForKey:LoginStatus];
}
-(NSString *)JID
{
    return [NSString stringWithFormat:@"%@@%@",self.username,@"fengyanyan.local"];
}
@end
