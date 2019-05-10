//
//  YYUtility+Locale.m
//  AFNetworking
//
//  Created by Ginvar on 2018/4/18.
//

#import "LGUtility.h"

@implementation LGUtility (Locale)


/**
 返回国家代码
 
 @return country Code
 */
+ (NSString *)countryCode{
//#if DEBUG
//    return @"ID";
//#endif
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    if (countryCode == nil) {
        countryCode = @"";
    }
    return countryCode;
}

/**
 返回语言代码
 
 @return country Code
 */
+ (NSString *)languageCode{
//#if DEBUG
//    return @"id";
//#endif
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *languageCode = [currentLocale objectForKey:NSLocaleLanguageCode];
    return languageCode;
}
    
/**
 返回语言代码
 
 @return country Code
 */
+ (NSString *)appleLanguages{
//#if DEBUG
//    return @"en-US";
//#endif
    NSString* strLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    return strLanguage;
}

+ (BOOL)isChinese {
    NSString* strLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if (!([strLanguage rangeOfString:@"zh-Hans"].length >0)) {
        
        return NO;
    }
    
    return YES;
}

@end
