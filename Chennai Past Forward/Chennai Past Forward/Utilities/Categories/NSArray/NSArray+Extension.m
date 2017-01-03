//
//  NSArray+Extension.m
//  Utilities
//
//  Created by Harish Kishenchand on 30/11/12.
//  Copyright (c) 2012 harish. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

- (BOOL)boolAtIndex:(NSUInteger)index{
    return [[self objectAtIndex:index] boolValue];
}

- (NSInteger)integerAtIndex:(NSUInteger)index{
    return [[self objectAtIndex:index] integerValue];
}

- (CGFloat)floatAtIndex:(NSUInteger)index{
    return [[self objectAtIndex:index] floatValue];
}

- (CGPoint)pointAtIndex:(NSUInteger)index{
    return [[self objectAtIndex:index] CGPointValue];
}

- (CGSize)sizeAtIndex:(NSUInteger)index{
    return [[self objectAtIndex:index] CGSizeValue];
}

- (CGRect)rectAtIndex:(NSUInteger)index{
    return [[self objectAtIndex:index] CGRectValue];
}

@end
