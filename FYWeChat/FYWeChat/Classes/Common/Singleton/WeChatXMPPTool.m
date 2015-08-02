//
//  WeChatXMPPTool.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/25.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatXMPPTool.h"

NSString *const WeChatLoginStatusChangeNotification=@"WeChatLoginStatusNotification";

@interface WeChatXMPPTool()<XMPPStreamDelegate>
{
    XMPPResaultBlock _resaultblock;
    
//    电子名片相关
    XMPPvCardCoreDataStorage *_vCardStorage; // 电子名片的数据存储
//    XMPPvCardTempModule *_vCard;//电子名片
    
//    头像模块
    XMPPvCardAvatarModule *_vCardAvatar;
    
//    自动连接模块
    XMPPReconnect *_reconnect;
    
//   聊天模块
    XMPPMessageArchiving *_message;
  
    
}
/*
 登陆的实现：
 1.初始化XMPPStream类
 2.连接到服务器  传一个JID到服务器
 3.连接到服务器成功以后，发送密码 进行授权
 4.授权成功之后，发送“在线”消息
 */
// 1.初始化XMPPStream类
-(void)SetUpXMPPStream;
//2.连接到服务器  传一个JID到服务器
-(void)ConnectToHost;
//3.连接到服务器成功以后，发送密码 进行授权
-(void)SendPasswordToHost;
//4.授权成功之后，发送“在线”消息
-(void)SenOnlineToHost;
//释放XMPP相关的资源
-(void)teardownXmpp;
@end

@implementation WeChatXMPPTool
singleton_implementation(WeChatXMPPTool)


#pragma mark --Private
//初始化XMPPStream
-(void)SetUpXMPPStream
{
    _xmppStream=[[XMPPStream alloc]init];

    #warning 每一个模块添加进去，均需要激活
    
//    添加自动连接模块
    _reconnect=[[XMPPReconnect alloc]init];
    [_reconnect activate:_xmppStream];
    

    //    添加花名册模块
    _rosterStorage=[XMPPRosterCoreDataStorage sharedInstance];
    _roster=[[XMPPRoster alloc]initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    
//    添加电子名片模块
    _vCardStorage=[XMPPvCardCoreDataStorage sharedInstance];
    _vCard=[[XMPPvCardTempModule alloc]initWithvCardStorage:_vCardStorage ];
 
//    激活
    [_vCard activate:_xmppStream];
    
// 头像模块
    _vCardAvatar=[[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_vCard];
//    激活
    [_vCardAvatar activate:_xmppStream];
    
//    添加聊天模块
    _messageStorage =[[XMPPMessageArchivingCoreDataStorage alloc]init];
    _message=[[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_messageStorage];
//    激活
    [_message activate:_xmppStream];
    
    _xmppStream.enableBackgroundingOnSocket=YES;
    
    //    设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}
//连接到服务器
-(void)ConnectToHost
{
    FYLog(@"开始连接到服务器");
    if (_xmppStream ==nil)
    {
        [self SetUpXMPPStream];
    }
//    调用方法发送通知
    [self PostNotification:XMPPResaultTypeConnecting];
    
    NSString *username=nil;
    if (self.isRegisterOperation) {
        //    从应用单例中获取用户名
        username=[WeChatUser sharedWeChatUser].registerUsername;
    }
    else
    {
        //    从应用单例中获取用户名
        username=[WeChatUser sharedWeChatUser].username;
    }
    //    NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    //    设置JID
    //    resource 标识用户登录的客户端
    XMPPJID *myJID=[XMPPJID jidWithUser:username domain:@"fengyanyan.local" resource:@"iphone"];
    _xmppStream.myJID=myJID;
    
    //    设置服务器的域名
    _xmppStream.hostName=@"fengyanyan.local";  //不仅可以是域名还可以是IP地址
    
    //    设置端口(如果服务器的端口是5222可以省略，5222为默认端口)
    _xmppStream.hostPort=5222;
    
    NSError *error=nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        FYLog(@"%@",error);
    }
}

-(void)PostNotification:(XMPPResaultType)resaultType
{
//    将登录状态放入字典  通过通知传递
    NSDictionary *userInfo=@{@"loginStatus":@(resaultType)};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WeChatLoginStatusChangeNotification object:nil userInfo:userInfo];
}

//  发送密码进行授权
-(void)SendPasswordToHost
{
    NSString *pwd=[WeChatUser sharedWeChatUser].pwd;
    //    从应用程序沙盒中获取密码
    //    NSString *pwd=[[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    FYLog(@"发送密码进行授权");
    NSError *error=nil;
    [_xmppStream authenticateWithPassword:pwd error:&error];
    if (error)
    {
        FYLog(@"%@",error);
    }
}
//授权成功之后，发送“在线”消息
-(void)SenOnlineToHost
{
    FYLog(@"发送在线消息");
    XMPPPresence *presence=[XMPPPresence presence];
    [_xmppStream sendElement:presence];
}
#pragma mark--释放XMPP相关资源
-(void)teardownXmpp
{
//   移除代理
    [_xmppStream removeDelegate:self];
//    停止模块
    [_reconnect deactivate];
    [_vCard deactivate];
    [_roster deactivate];
    [_message deactivate];
//    断开连接
    [_xmppStream disconnect];
//    清空资源
    _reconnect=nil;
    _vCard=nil;
    _vCardStorage=nil;
    _vCardAvatar=nil;
    _xmppStream=nil;
    _roster=nil;
    _rosterStorage=nil;
    _message=nil;
    _messageStorage=nil;
}
#pragma mark --XMPPStreamDelegate
#pragma mark --与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    FYLog(@"与主机连接成功");
    if (self.isRegisterOperation) {//注册操作
        NSString *pwd=[WeChatUser sharedWeChatUser].registerPwd;
        //    连接成功时，有可能做注册操作  发送注册的密码到服务器
        [_xmppStream registerWithPassword:pwd error:nil];
    }else{//登录操作
        //    3.发送密码进行授权
        [self SendPasswordToHost];
    }
}
#pragma mark --与主机断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    
    if (error && _resaultblock) {
        _resaultblock(XMPPResaultTypeNetError);
    }
    
    if (error)
    {
        FYLog(@"与主机连接失败 %@",error);
//        通知网络不稳定   通知historyviewcontroller
        [self PostNotification:XMPPResaultTypeNetError];
    }
    
    
}
#pragma mark --密码发送  授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    FYLog(@"授权成功");
    //    授权成功之后 发送“在线”消息
    [self SenOnlineToHost];
    if (_resaultblock)
    {
        _resaultblock(XMPPResaultTypeLoginSuccess);
    }
    
    [self PostNotification:XMPPResaultTypeLoginSuccess];
}
#pragma mark --密码发送  授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    FYLog(@"授权失败");
    //    判断block是否有值  再回调给登陆控制器
    FYLog(@"%@",_resaultblock);
    if (_resaultblock)
    {
        _resaultblock(XMPPResaultTypeLoginFailure);
    }
    
    [self PostNotification:XMPPResaultTypeLoginFailure];
}
#pragma mark --注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    FYLog(@"注册成功");
    if (_resaultblock) {
        _resaultblock(XMPPResaultTypeRegisterSuccess);
    }
}
#pragma mark --注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    FYLog(@"注册失败");
    if (_resaultblock) {
        _resaultblock(XMPPResaultTypeRegisterFailure);
    }
}
#pragma mark --收到好友消息调用的方法
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"%@",message);
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        FYLog(@"应用程序在后台");
//        设置本地通知
        UILocalNotification *localnoti=[[UILocalNotification alloc]init];
//        设置通知的内容
        localnoti.alertBody=[NSString stringWithFormat:@"%@\n%@",message.fromStr,message.body];
//        设置通知执行的时间
        localnoti.fireDate=[NSDate date];
//        设置声音
        localnoti.soundName=@"default";
//        执行通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localnoti];
    }
}
#pragma mark -- 公共方法
-(void)login:(XMPPResaultBlock)resaultBlock
{
    //    1.先把block存起来
    _resaultblock=resaultBlock;
    //   先断开之前与服务器的连接
    [_xmppStream disconnect];
    //    连接到主机  连接成功之后发送登录密码给服务器
    [self ConnectToHost];
}
-(void)logout
{
    //
    [WeChatUser sharedWeChatUser].loginStatus=NO;
    [[WeChatUser sharedWeChatUser] saveUserInfoToSanBox];
    //    1.发送“离线”消息
    XMPPPresence *offline=[XMPPPresence presenceWithType:@"unavailable"];
    FYLog(@"%@",offline);
    [_xmppStream sendElement:offline];
    //    2.与服务器断开连接
    [_xmppStream disconnect];
    
    //    3.回到登陆界面
//    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
////    self.window.rootViewController=storyboard.instantiateInitialViewController;
    [UIStoryboard showInitialVCWithName:@"Login"];
    //        4.更新用户的登录状态
    [WeChatUser sharedWeChatUser].loginStatus=NO;
    [[WeChatUser sharedWeChatUser] saveUserInfoToSanBox];
}
//用户的注册方法
-(void)register:(XMPPResaultBlock)resaultBlock
{
    //    1.先把block存起来
    _resaultblock=resaultBlock;
    //   先断开之前与服务器的连接
    [_xmppStream disconnect];
    //    连接到主机  连接成功之后发送注册的密码给服务器
    [self ConnectToHost];
}
-(void)dealloc
{
    [self teardownXmpp];
}

@end
