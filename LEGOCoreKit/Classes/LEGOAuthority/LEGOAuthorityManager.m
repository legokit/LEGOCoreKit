//
//  FCAuthorityManager.m
//  FilmCamera
//
//  Created by 黄亚栋 on 2018/12/28.
//  Copyright © 2018 The last stand. All rights reserved.
//

#import "LEGOAuthorityManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CoreLocation.h>

#include <sys/param.h>
#include <sys/mount.h>

@implementation LEGOAuthorityManager

// 相机访问权限
+ (BOOL)cameraAuthority {    
    __block BOOL isAuthority = NO;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                isAuthority = granted;
                dispatch_semaphore_signal(sema);
            }];
            break;
        }
        case AVAuthorizationStatusDenied:{
            isAuthority = NO;
            dispatch_semaphore_signal(sema);
            break;
        }
        default:{
            isAuthority = YES;
            dispatch_semaphore_signal(sema);
            break;
        }
    }
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return isAuthority;
}

+ (void)cameraAuthorityWithBlock:(CameraAuthorityeBlock)block {
    if (![self.class getDivceSize]) {
        return;
    }
    __block BOOL isAuthority = NO;
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                isAuthority = granted;
                if (block) {
                    block(isAuthority);
                }
            }];
            break;
        }
        case AVAuthorizationStatusDenied:{
            isAuthority = NO;
            if (block) {
                block(isAuthority);
            }
            break;
        }
        default:{
            isAuthority = YES;
            if (block) {
                block(isAuthority);
            }
            break;
        }
    }
}

+ (void)cameraAuthorityDenied:(void (^)(void))denied {
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusDenied:{
            // 弹窗 去到设置页面 开启相机权限
            !denied ? :denied();
            break;
        }
        default:{
            break;
        }
    }
}



// 相册访问权限
+ (BOOL)albumAuthority {
    __block BOOL isAuthority = NO;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusNotDetermined:{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    isAuthority = YES;
                }else if (status == PHAuthorizationStatusDenied) {
                    isAuthority = NO;
                }
                dispatch_semaphore_signal(sema);
            }];
            break;
        }
        case PHAuthorizationStatusDenied:{
            isAuthority = NO;
            dispatch_semaphore_signal(sema);
            break;
        }
        default:{
            isAuthority = YES;
            dispatch_semaphore_signal(sema);
            break;
        }
    }
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return isAuthority;
}

// 消息通知
+ (BOOL)notificationAuthority {
    __block BOOL isAuthority = NO;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    UIUserNotificationSettings *notification = [UIApplication sharedApplication].currentUserNotificationSettings;
    if (notification == UIUserNotificationTypeNone) {
        if (@available(iOS 10.0, *)) {
            [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                if ([settings authorizationStatus] == UNAuthorizationStatusNotDetermined) {
                    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert|UNAuthorizationOptionCarPlay completionHandler:^(BOOL granted, NSError * _Nullable error) {
                        isAuthority = granted;
                        dispatch_semaphore_signal(sema);
                    }];
                }else if ([settings authorizationStatus] == UNAuthorizationStatusDenied) {
                    isAuthority = NO;
                    dispatch_semaphore_signal(sema);
                }else {
                    isAuthority = YES;
                    dispatch_semaphore_signal(sema);
                }
            }];
        } else {
            UIUserNotificationSettings *notificationSet = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSet];
            isAuthority = YES;
            dispatch_semaphore_signal(sema);
        }
    }else {
        isAuthority = YES;
        dispatch_semaphore_signal(sema);
    }
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return isAuthority;
}

// 地理位置
+ (BOOL)locationAuthority {
    BOOL isAuthority = NO;
    
    if ([CLLocationManager locationServicesEnabled]) {
        // 弹出url弹窗
        isAuthority =  NO;
    }
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusDenied:
            // 弹出url弹窗
            isAuthority = NO;
            break;
        default:
            isAuthority = YES;
            break;
    }
    return isAuthority;
}

// 手机内存检测
+ (BOOL)getDivceSize{
    BOOL spaceEnough = YES;
    
    //可用大小
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bavail);
    }
//    //总大小
//    struct statfs buf1;
//    long long maxspace = 0;
//    if (statfs("/", &buf1) >= 0) {
//        maxspace = (long long)buf1.f_bsize * buf1.f_blocks;
//    }
//    if (statfs("/private/var", &buf1) >= 0) {
//        maxspace += (long long)buf1.f_bsize * buf1.f_blocks;
//    }
//    NSString * sizeStr = [NSString stringWithFormat:@"可用空间%0.2fM / 总空间%0.2fM",(CGFloat)freespace/1024/1024,(CGFloat)maxspace/1024/1024];
    CGFloat freedomSpace = (CGFloat)freespace/1024/1024;
    if (freedomSpace <= 200) {
        spaceEnough = NO;
    }else {
        spaceEnough = YES;
    }
    
    return spaceEnough;
}

@end
