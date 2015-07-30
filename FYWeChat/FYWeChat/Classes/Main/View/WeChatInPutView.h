//
//  WeChatInPutView.h
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/30.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeChatInPutView : UIView
@property (weak, nonatomic) IBOutlet UITextView *Text;
+(instancetype)inputView;
@end
