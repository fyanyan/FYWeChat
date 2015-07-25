//
//  WeChatRegisterViewController.h
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/20.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeChatRegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *PhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *Pwd;
- (IBAction)Register:(id)sender;
- (IBAction)Back:(id)sender;

@end
