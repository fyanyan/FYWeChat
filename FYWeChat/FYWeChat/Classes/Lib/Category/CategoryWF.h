//
//  CategoryWF.h
//  WeiXin
//
//  Created by Yong Feng Guo on 14-11-19.
//  Copyright (c) 2014年 Fung. All rights reserved.
//
#import "DDASLLogger.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

#ifndef WeiXin_CategoryWF_h
#define WeiXin_CategoryWF_h
#import "UIView+WF.h"
#import "UIButton+WF.h"
#import "UIImage+WF.h"
#import "UIStoryboard+WF.h"
#import "UITextField+WF.h"
#import "UIScreen+WF.h"


#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_OFF;
#endif


#endif
