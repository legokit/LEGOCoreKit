//
//  NSString+Time.h
//  FilmCamera
//
//  Created by errnull on 2019/1/10.
//  Copyright © 2019 The last stand. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Time)

+ (NSString *)getCurrentTimeString;

+ (NSString *)getCurrentTimeByFormat:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
