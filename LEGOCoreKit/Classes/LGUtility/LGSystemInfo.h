//
//  FCInfo.h
//  FilmCamera
//
//  Created by 黄亚栋 on 2018/12/26.
//  Copyright © 2018 The last stand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGSystemInfo : NSObject

// 设备名称 My iPhone
+ (NSString *)deviceName;
// 设备机型 iPhone 6
+ (NSString *)deviceModelName;
// app版本号 1.0.0
+ (NSString *)appVersionShort;
// 设备UUID
+ (NSString *)UUID;
// 设备系统   iOS
+ (NSString *)systemName;
// 设备系统版本 12.1
+ (NSString *)systemVersion;

@end

NS_ASSUME_NONNULL_END
