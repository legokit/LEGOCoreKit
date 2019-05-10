//
//  UIScreen+Utility.m
//  YYMobile
//
//  Created by fang jiehua on 14-10-21.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import "UIScreen+Utility.h"

@implementation UIScreen(Utility)

+ (CGRect)screenBoundsFixedToPortraitOrientation {
    
    CGRect screen = [UIScreen mainScreen].bounds;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGRectMake(screen.origin.x, screen.origin.y, screen.size.height, screen.size.width);
    } else {
        return screen;
    }
}

+ (CGFloat)scaleForWidth320 {
    static CGFloat scale = 0;
    if (scale == 0) {
        CGRect bounds = [UIScreen screenBoundsFixedToPortraitOrientation];
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            scale = bounds.size.height/320.0;
        }
        else
        {
            scale = bounds.size.width/320.0;
        }
    }
    
    return scale;
}

+ (UIImage *)yy_getScreenshot{
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    UIGraphicsBeginImageContextWithOptions(bounds.size,NO,[UIScreen mainScreen].scale);
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    
    return screenshot;
}

@end
