//
//  NSDate+String.h
//  FilmCamera
//
//  Created by errnull on 2019/1/18.
//  Copyright © 2019 The last stand. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (String)

- (NSString *)dateStringWithFormatterString:(NSString *)formatterString;

+ (NSDate *)dateWithDateString:(NSString *)dataString formatterString:(NSString *)formatterString;


@end

NS_ASSUME_NONNULL_END
