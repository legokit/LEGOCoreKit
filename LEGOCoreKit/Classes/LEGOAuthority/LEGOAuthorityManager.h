//
//  FCAuthorityManager.h
//  FilmCamera
//
//  Created by 黄亚栋 on 2018/12/28.
//  Copyright © 2018 The last stand. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CameraAuthorityeBlock)(BOOL isAuthority) ;

NS_ASSUME_NONNULL_BEGIN

@interface LEGOAuthorityManager : NSObject

// 相机访问权限
+ (BOOL)cameraAuthority;

+ (void)cameraAuthorityWithBlock:(CameraAuthorityeBlock)block;

+ (void)cameraAuthorityDenied:(void (^)(void))denied;

// 相册访问权限
+ (BOOL)albumAuthority;

// 消息通知
+ (BOOL)notificationAuthority;

// 地理位置
+ (BOOL)locationAuthority;

// 手机内存检测
+ (BOOL)getDivceSize;

@end

NS_ASSUME_NONNULL_END
