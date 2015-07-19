//
//  WeChatLoginViewController.h
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/19.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeChatLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *userLable;
@property (weak, nonatomic) IBOutlet UITextField *Pwd;
- (IBAction)Login:(id)sender;

- (IBAction)ForgetPwd:(id)sender;


@end
