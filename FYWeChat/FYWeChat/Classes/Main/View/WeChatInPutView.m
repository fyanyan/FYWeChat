//
//  WeChatInPutView.m
//  FYWeChat
//
//  Created by 冯琰琰 on 15/7/30.
//  Copyright (c) 2015年 冯琰琰. All rights reserved.
//

#import "WeChatInPutView.h"

@implementation WeChatInPutView

+(instancetype)inputView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"WeChatInPutView" owner:nil options:nil] lastObject];
}

@end
