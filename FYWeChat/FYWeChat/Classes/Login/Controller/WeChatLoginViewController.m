//
//  WeChatLoginViewController.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/19.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatLoginViewController.h"

@interface WeChatLoginViewController ()

@end

@implementation WeChatLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    从沙盒中获取用户名
    self.userLable.text=[WeChatUser sharedWeChatUser].username;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)Login:(id)sender {
}


- (IBAction)ForgetPwd:(id)sender {
}
@end
