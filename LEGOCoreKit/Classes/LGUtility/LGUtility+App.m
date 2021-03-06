//
//  YYUtility+App.m
//  YYMobileFramework
//
//  Created by wuwei on 14-5-30.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import "LGUtility.h"

@implementation LGUtility (App)

+ (id)valueInPlistForKey:(NSString *)key
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:key];
}

static NSString *s_yyVersion;
+ (void)setYYVersion:(NSString *)yyVersion
{
    s_yyVersion = yyVersion;
}

+ (NSString *)yyVersion
{
    if (!s_yyVersion) {
        s_yyVersion = [self valueInPlistForKey:@"CFBundleShortVersionString"];
    }
    return s_yyVersion;
}

+ (NSString *)appVersion
{
    static NSString *appVersion = nil;
    if (!appVersion) {
        appVersion = [self valueInPlistForKey:@"CFBundleShortVersionString"];
    }
    return appVersion;
}

+ (NSString *)appBuild
{
    static NSString *appBuild = nil;
    if (!appBuild) {
        appBuild = [self valueInPlistForKey:(NSString *)kCFBundleVersionKey];
    }
    return appBuild;
}

+ (NSString *)appBundleId
{
    static NSString *appBundleId = nil;
    if (!appBundleId) {
        appBundleId = [self valueInPlistForKey:(NSString *)kCFBundleIdentifierKey];
    }
    return appBundleId;
}


+ (NSString *)svnVersion
{
    static NSString *svnVersion = nil;
    if (!svnVersion) {
        svnVersion = [self valueInPlistForKey:@"SvnBuildVersion"];
    }
    if (!svnVersion) {
        svnVersion = @"";
    }
    return svnVersion;
}

+ (NSString *)systemType
{
    return @"2"; // Platform_iOS
}

static NSString *s_compAppId;
+ (void)setCompAppid:(NSString *)appId
{
    s_compAppId = appId;
}

+ (NSString *)compAppid {
    if (!s_compAppId) {
        s_compAppId = @"iyoyiip";
    }
    return s_compAppId;
}

static NSString * const kMobileFrameworkResourceBundleName = @"YYMobileFrameworkRes";

+ (NSURL *)URLForMobileFrameworkResourceBundle
{
    return [[NSBundle mainBundle] URLForResource:kMobileFrameworkResourceBundleName
                                   withExtension:@"bundle"];
}

+ (NSString *)pathForMobileFrameworkResourceBundle
{
    return [[NSBundle mainBundle] pathForResource:kMobileFrameworkResourceBundleName
                                           ofType:@"bundle"];
}

+ (NSString *)buildType
{
#if (DISTRIBUTE || POD_CONFIGURATION_DISTRIBUTE)
    return @"Distribute";
#else
    #ifdef DEBUG
        return @"DEBUG";
    #else
        return @"RELEASE";
    #endif
#endif
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)fileURL
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]]) {
        NSLog(@"File %@ dosen't exist!", fileURL);
        return NO;
    }
    
    NSError *error = nil;
    BOOL result = [fileURL setResourceValue:[NSNumber numberWithBool:YES]
                                     forKey:NSURLIsExcludedFromBackupKey
                                      error:&error];
    if (!result) {
        NSLog(@"Error excluding '%@' from backup, error: %@.", fileURL, error);
    }
    
    return result;
}

static NSString *_from = nil;

+ (void)setAppSource:(NSString *)appSource {
    _from = appSource;
}

+ (NSString *)getAppSource
{
    if (_from == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sourceid.dat" ofType:nil];
        
        NSError *error;
        NSString *from = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        
        // 去除换行及空格
        if (from) {
            from = [self removeSpaceAndNewline:from];
        }
        
        // 如果读到有值且不为0
        if (!error
            && ![from isEqualToString:@"0"]
            && ![from isEqualToString:@""]) {
            _from = from;
        } else {
            _from =  @"appstore";
        }
    }
    
    return _from;
}

+ (BOOL)isFromAppStore
{
    if([[[LGUtility getAppSource] lowercaseString] isEqualToString:@"appstore"])
    {
        return YES;
    }
    return NO;
}


+ (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

@end
