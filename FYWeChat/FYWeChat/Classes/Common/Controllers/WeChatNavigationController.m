//
//  WeChatNavigationController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/19.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatNavigationController.h"

@interface WeChatNavigationController ()

@end

@implementation WeChatNavigationController

+(void)initialize
{
    
}

+(void)setupNaBarThem
{
    UINavigationBar *nabar=[UINavigationBar appearance];
    //    设置导航的样式
    //    1.设置导航条的背景
//    高度不会被拉伸 但是宽度会被拉伸
    [nabar setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    //    2.设置导航栏的字体
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName]=[UIColor whiteColor];
    dic[NSFontAttributeName]=[UIFont systemFontOfSize:20];
    
    [nabar setTitleTextAttributes:dic];
    
//    3.设置状态栏的样式
//  Xcode5以上版本  默认的情况下 状态栏的样式由控制器决定的
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
}

//结论：如果控制器是由导航控制器管理的，设置状态栏的样式时，要在导航控制器里设置
//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
@end
