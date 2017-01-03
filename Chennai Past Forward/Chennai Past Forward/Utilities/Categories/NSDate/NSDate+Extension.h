//
//  NSDate+Extension.h
//  Utilities
//
//  Created by Harish Kishenchand on 01/12/12.
//  Copyright (c) 2012 harish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;
@end