//
//  AppDelegate.m
//  FYWeChat
//
//  Created by fengyan on 15/7/17.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
@interface AppDelegate ()
{
    XMPPStream *_xmppStream;
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
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark --Private
//初始化XMPPStream
-(void)SetUpXMPPStream
{
    _xmppStream=[[XMPPStream alloc]init];
    //    设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}
//连接到服务器
-(void)ConnectToHost
{
    NSLog(@"开始连接到服务器");
    if (_xmppStream ==nil)
    {
        [self SetUpXMPPStream];
    }
    //    设置JID
    //    resource 标识用户登录的客户端
    XMPPJID *myJID=[XMPPJID jidWithUser:@"lisi" domain:@"fengyanyan.local" resource:@"iphone"];
    _xmppStream.myJID=myJID;
    
    //    设置服务器的域名
    _xmppStream.hostName=@"fengyanyan.local";  //不仅可以是域名还可以是IP地址
    
    //    设置端口(如果服务器的端口是5222可以省略，5222为默认端口)
    _xmppStream.hostPort=5222;
    
    NSError *error=nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        NSLog(@"%@",error);
    }
}
//  发送密码进行授权
-(void)SendPasswordToHost
{
    NSLog(@"发送密码进行授权");
    NSError *error=nil;
    [_xmppStream authenticateWithPassword:@"123456" error:&error];
    if (error)
    {
        NSLog(@"%@",error);
    }
}
//授权成功之后，发送“在线”消息
-(void)SenOnlineToHost
{
    NSLog(@"发送在线消息");
    XMPPPresence *presence=[XMPPPresence presence];
    [_xmppStream sendElement:presence];
}
#pragma mark --XMPPStreamDelegate
#pragma mark --与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"与主机连接成功");
    //    3.发送密码进行授权
    [self SendPasswordToHost];
}
#pragma mark --与主机断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    if (error)
    {
        NSLog(@"与主机连接失败 %@",error);
    }
}
#pragma mark --密码发送  授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"授权成功");
    //    授权成功之后 发送“在线”消息
    [self SenOnlineToHost];
}
#pragma mark --密码发送  授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"授权失败");
}
#pragma mark -- 公共方法
-(void)logout
{
    //    1.发送“离线”消息
    XMPPPresence *offline=[XMPPPresence presenceWithType:@"unavailable"];
    NSLog(@"%@",offline);
    [_xmppStream sendElement:offline];
    //    2.与服务器断开连接
    [_xmppStream disconnect];
}
@end
