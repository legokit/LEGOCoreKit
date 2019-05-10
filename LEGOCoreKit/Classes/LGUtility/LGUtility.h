//
//  YYUtility.h
//  YYMobileFramework
//
//  Created by wuwei on 14/6/11.
//  Copyright (c) 2014年 YY.inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LGUtility : NSObject

@end

/*==============================*/
/*      App Utilities           */
/*==============================*/
@interface LGUtility (App)

/**
 *  从YYMobile-Info.plist中读取字段
 *
 *  @param key 键
 *
 *  @return 值
 */
+ (id)valueInPlistForKey:(NSString *)key;

/**
 *  如果作为SDK使用，则是由外部指定
 */
+ (void)setYYVersion:(NSString *)yyVersion;
/**
 *  获取App版本号, 从plist从读取CFBundleShortVersion
 *  如果作为SDK使用，则是由外部指定
 */
+ (NSString *)yyVersion;

/**
 *  获取App版本号, 从plist从读取CFBundleShortVersion
 */
+ (NSString *)appVersion;

/**
 *  获取AppBuild号, 从plist中读取CFBundleVersion
 */
+ (NSString *)appBuild;

/**
 *  当前构建出的版本在svn中的版本号
 */
+ (NSString *)svnVersion;

/*
 *  系统类型
 */
+ (NSString *)systemType;

/*
 *  应用统一标示: 外部设定
 */
+ (void)setCompAppid:(NSString *)appId;

/*
 *  应用统一标示
 */
+ (NSString *)compAppid;

/**
 *  获取bundle id
 *
 *  @return bundle id
 */
+ (NSString *)appBundleId;

/**
 *  获取YYMobileFrameworkRes.bundle的URL
 */
+ (NSURL *)URLForMobileFrameworkResourceBundle;

/**
 *  获取YYMobileFrameworkRes.bundle的路径
 */
+ (NSString *)pathForMobileFrameworkResourceBundle;

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)fileURL;

/**
 *  获取当前的构建类型(DEBUG/RELEASE)
 *
 *  @return 构建类型
 */
+ (NSString *)buildType;

/*
 *  app来源: 外部设定
 */
+ (void)setAppSource:(NSString *)appSource;

/**
 * 获取平台渠道
 */
+ (NSString *)getAppSource;

/**
 * 是否来自appstore
 */
+ (BOOL)isFromAppStore;

@end

/*==============================*/
/*      Device Utilities        */
/*==============================*/
@interface LGUtility (Device)

/**
 *  获取modelName, 如iPhone5,2
 */
+ (NSString *)modelName;

/**
 *  获取系统版本
 */
+ (NSString *)systemVersion;

/**
 *  获取系统名字及版本，如iPhone OS-10.1。充值及相关协议用到。
 */
+ (NSString *)userAgent;

/**
 *  获取当前设备的 IDFV，IDFV 在某些情况下会变，不建议将其作为设备标识
 */
+ (NSString *)identifierForVendor NS_AVAILABLE_IOS(6_0);

// 当前电量
+ (float)currentBtteryLevel;

// 设备是否正在充电
+ (BOOL)isDeviceCharging;

/**
 *  获取当前IP地址
 */
+ (NSString *)ipAddress;

/**
 *  获取当前IP地址
 *
 *  @param preferIPv4 优先取IPv4的地址 
 */
+ (NSString *)ipAddress:(BOOL)preferIPv4;

+ (NSString *)macAddresss;

/**
 *  初始化信令sdk，imsdk所用到的appName
 *
 *  @return app name
 */
+ (NSString *)appName;


/**
 初始化udbsdk，用到的非web密匙

 @return app key
 */
+ (NSString *)appKey;

@end

@interface LGUtility (Locale)

/**
 返回国家代码
 
 @return country Code
 */
+ (NSString *)countryCode;

/**
 返回语言代码
 
 @return country Code
 */
+ (NSString *)languageCode;
+ (NSString *)appleLanguages;

+ (BOOL)isChinese;

@end
