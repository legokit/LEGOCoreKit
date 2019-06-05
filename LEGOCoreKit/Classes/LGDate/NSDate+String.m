//
//  NSDate+String.m
//  FilmCamera
//
//  Created by errnull on 2019/1/18.
//  Copyright © 2019 The last stand. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate (String)

- (NSString *)dateStringWithFormatterString:(NSString *)formatterString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatterString];
    return [dateFormatter stringFromDate:self];
}

+ (NSDate *)dateWithDateString:(NSString *)dataString formatterString:(NSString *)formatterString {
    //先把旧的字符串日期转日期对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatterString;
    NSDate* date = [formatter dateFromString:dataString];
    return date;
}


@end
