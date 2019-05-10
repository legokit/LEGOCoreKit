//
//  UIScreen+Utility.h
//  YYMobile
//
//  Created by fang jiehua on 14-10-21.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScreen(Utility)

+ (CGRect)screenBoundsFixedToPortraitOrientation;
+ (CGFloat)scaleForWidth320;
+ (UIImage *)yy_getScreenshot;

@end
