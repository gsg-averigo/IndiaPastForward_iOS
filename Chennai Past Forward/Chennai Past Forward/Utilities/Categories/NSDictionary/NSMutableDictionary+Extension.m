//
//  NSMutableDictionary+Extension.m
//  Utilities
//
//  Created by Harish Kishenchand on 30/11/12.
//  Copyright (c) 2012 harish. All rights reserved.
//

#import "NSMutableDictionary+Extension.h"

@implementation NSMutableDictionary (Extension)

- (void)setBool:(BOOL)aValue forKey:(NSString *)aKey{
    [self setObject:[NSNumber numberWithBool:aValue] forKey:aKey];
}

- (void)setInteger:(NSInteger)aValue forKey:(NSString *)aKey{
    [self setObject:[NSNumber numberWithInteger:aValue] forKey:aKey];
}

- (void)setFloat:(CGFloat)aValue forKey:(NSString *)aKey{
    [self setObject:[NSNumber numberWithFloat:aValue] forKey:aKey];
}

- (void)setPoint:(CGPoint)aValue forKey:(NSString *)aKey{
    [self setObject:[NSValue valueWithCGPoint:aValue] forKey:aKey];
}

- (void)setSize:(CGSize)aValue forKey:(NSString *)aKey{
    [self setObject:[NSValue valueWithCGSize:aValue] forKey:aKey];
}

- (void)setRect:(CGRect)aValue forKey:(NSString *)aKey{
    [self setObject:[NSValue valueWithCGRect:aValue] forKey:aKey];
}

@end