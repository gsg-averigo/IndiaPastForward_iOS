//
//  NSDate+Extension.m
//  Utilities
//
//  Created by Harish Kishenchand on 01/12/12.
//  Copyright (c) 2012 harish. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSDate *)dateFromString:(NSString *)dateString{
    if(!dateString || dateString.length == 0){
        return nil;
    }
    
    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate error:&error];

    NSTextCheckingResult *result = [detector firstMatchInString:dateString options:0 range:NSMakeRange(0, [dateString length])];
    return [result date];
}

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

- (NSString *)stringWithFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

@end
