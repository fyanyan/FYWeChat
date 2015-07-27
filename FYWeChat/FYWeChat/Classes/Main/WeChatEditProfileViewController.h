//
//  WeChatEditProfileViewController.h
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/27.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import <UIKit/UIKit.h>




@protocol EditProfileViewControllerdelegate <NSObject>

-(void)editProfileViewControllerDidSava;

@end





@interface WeChatEditProfileViewController : UITableViewController
@property(nonatomic,strong)UITableViewCell *profileCell;
@property(nonatomic,weak)id<EditProfileViewControllerdelegate> delegate;
@end
