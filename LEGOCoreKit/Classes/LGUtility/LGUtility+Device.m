//
//  YYUtility+Device.m
//  YYMobileFramework
//
//  Created by wuwei on 14-5-30.
//  Copyright (c) 2014年 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "LGUtility.h"
#import <sys/utsname.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <ifaddrs.h>
#import <ifaddrs.h>
#import <net/if_dl.h>
#import <sys/socket.h>


#if !defined(IFT_ETHER)
#define IFT_ETHER 0x6
#endif

#define kIOSCellular    @"pdp_ip0"
#define kIOSWifi        @"en0"
#define kIPAddrV4       @"ipv4"
#define kIPAddrV6       @"ipv6"

static NSString * const kAppName = @"yym115ip";
static NSString * const kAppKey = @"s4Bl00BNWZHntHIZQdUbBwoOQoN7eql5";
static NSString * const kWebKey = @"IsRMW9iHJ8j5zTbuzxMJEn5I9iAUaqc3";


@implementation LGUtility (Device)

+ (NSString *)modelName
{
    static NSString *modelName = nil;
    if (!modelName) {
        struct utsname systemInfo;
        uname(&systemInfo);
        modelName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    }
    return modelName;
}

+ (NSString *)systemVersion
{
    // 调用非常频繁，主要在cleanSpecialText中
    static NSString* _systemVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _systemVersion = [UIDevice currentDevice].systemVersion;
    });
    
    if (_systemVersion) {
        return _systemVersion;
    }
    
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)userAgent {
    //[UIDevice currentDevice].systemName : 在iOS10，返回iOS；iOS10之前，返回iPhone OS. 为兼容，现写死为iPhone OS.
    return [@"iPhone OS-" stringByAppendingString:[UIDevice currentDevice].systemVersion];
}

+ (NSString *)identifierForVendor
{
    static NSString *idfv = nil;
    if (!idfv) {
        idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return idfv;
}

+ (NSString *)appName
{
    return kAppName;
}

+ (NSString *)appKey
{
    return kAppKey;
}

+ (NSString *)ipAddress
{
    return [self ipAddress:YES];
}

+ (NSString *)ipAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
        @[ kIOSWifi @"/" kIPAddrV4, kIOSWifi @"/" kIPAddrV6, kIOSCellular @"/" kIPAddrV4, kIOSCellular @"/" kIPAddrV6 ] :
        @[ kIOSWifi @"/" kIPAddrV6, kIOSWifi @"/" kIPAddrV4, kIOSCellular @"/" kIPAddrV6, kIOSCellular @"/" kIPAddrV4 ] ;
    
    NSDictionary *addresses = [self getIpAddresses];
    
    __block NSString *addr;
    [searchArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        addr = addresses[obj];
        if (addr) {
            *stop = YES;
        }
    }];
    return addr ? : @"0.0.0.0";
}

+ (NSDictionary *)getIpAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionary];
    
    // retrieve the current interfaces - return 0 on success
    struct ifaddrs *interfaces;
    if (!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for (interface = interfaces; interface; interface = interface->ifa_next) {
            if (!(interface -> ifa_flags & IFF_UP)) {
                continue;
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in *)interface->ifa_addr;
            char addrBuf[MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) + 2];
            if (addr && (addr->sin_family == AF_INET || addr->sin_family == AF_INET6)) {
                NSString *ifaName = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *ifaType;
                if (addr->sin_family == AF_INET) {
                    if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        ifaType = kIPAddrV4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6 *)interface->ifa_addr;
                    if (inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        ifaType = kIPAddrV6;
                    }
                }
                if (ifaType) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", ifaName, ifaType];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
    }
    // free memory
    freeifaddrs(interfaces);
    return addresses;
}

+ (NSString *)macAddresss
{
    static NSMutableString *macAddress = nil;
    
    if ([macAddress length] > 0) {
        return macAddress;
    }
    
    do
    {
        struct ifaddrs* addrs;
        if ( getifaddrs( &addrs ) )
            break;
        
        const struct ifaddrs *cursor = addrs;
        while ( cursor )
        {
            if ( ( cursor->ifa_addr->sa_family == AF_LINK )
                && strcmp( "en0",  cursor->ifa_name ) == 0
                && ( ( ( const struct sockaddr_dl * )cursor->ifa_addr)->sdl_type == IFT_ETHER ) )
            {
                const struct sockaddr_dl *dlAddr = ( const struct sockaddr_dl * )cursor->ifa_addr;
                const uint8_t *base = ( const uint8_t * )&dlAddr->sdl_data[dlAddr->sdl_nlen];
                
                macAddress = [[NSMutableString alloc] initWithCapacity:64];
                
                for ( int i = 0; i < dlAddr->sdl_alen; i++ )
                {
                    if (i > 0) {
                        [macAddress appendFormat:@":%02X", base[i]];
                    }
                    else
                    {
                        [macAddress appendFormat:@"%02X", base[i]];
                    }
                }
                
                break;
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    } while (NO);
    
    if (macAddress == nil) {
        macAddress = [NSMutableString stringWithString:@""];
    }
    
    return macAddress;
}


// 当前电量
+ (float)currentBtteryLevel {
    
    return [[UIDevice currentDevice] batteryLevel];
}

// 设备是否正在充电
+ (BOOL)isDeviceCharging {
    
    return [[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging;
}

@end
