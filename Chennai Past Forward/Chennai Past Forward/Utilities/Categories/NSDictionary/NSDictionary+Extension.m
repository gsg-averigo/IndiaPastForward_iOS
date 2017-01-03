//
//  NSDictionary+Extension.m
//  Utilities
//
//  Created by Harish Kishenchand on 30/11/12.
//  Copyright (c) 2012 harish. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

- (BOOL)containsKey:(NSString *)aKey
{
    return [[self allKeys] containsObject:aKey];
}

- (BOOL)boolForKey:(NSString *)aKey{
    return [[self objectForKey:aKey] boolValue];
}

- (NSInteger)integerForKey:(NSString *)aKey{
    return [[self objectForKey:aKey] integerValue];
}

- (CGFloat)floatForKey:(NSString *)aKey{
    return [[self objectForKey:aKey] floatValue];
}

- (CGPoint)pointForKey:(NSString *)aKey{
    return [[self objectForKey:aKey] CGPointValue];
}

- (CGSize)sizeForKey:(NSString *)aKey{
    return [[self objectForKey:aKey] CGSizeValue];
}

- (CGRect)rectForKey:(NSString *)aKey{
    return [[self objectForKey:aKey] CGRectValue];
}

@end
