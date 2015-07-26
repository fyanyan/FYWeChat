//
//  WeChatLoginViewController.h
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/19.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatBaseViewController.h"

@interface WeChatLoginViewController : WeChatBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *userLable;
@property (weak, nonatomic) IBOutlet UITextField *Pwd;
//登陆
- (IBAction)Login:(id)sender;
//忘记密码
- (IBAction)ForgetPwd:(id)sender;
//注册
- (IBAction)MyRegister:(id)sender;
- (IBAction)OtherLogin:(id)sender;


@end
