//
//  NSString+Time.m
//  FilmCamera
//
//  Created by errnull on 2019/1/10.
//  Copyright © 2019 The last stand. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)

+ (NSString*)getCurrentTimeString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY_MM_dd_HH_mm_ss"];
    NSDate *now = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:now];
    return currentTimeString;
}

+ (NSString *)getCurrentTimeByFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *now = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:now];
    return currentTimeString;
}

@end
