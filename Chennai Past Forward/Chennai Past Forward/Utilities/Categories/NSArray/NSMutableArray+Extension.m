//
//  NSMutableArray+Extension.m
//  Utilities
//
//  Created by Harish Kishenchand on 30/11/12.
//  Copyright (c) 2012 harish. All rights reserved.
//

#import "NSMutableArray+Extension.h"

@implementation NSMutableArray (Extension)

- (void)addBool:(BOOL)aValue{
    [self addObject:[NSNumber numberWithBool:aValue]];
}

- (void)addInteger:(NSInteger)aValue{
    [self addObject:[NSNumber numberWithInteger:aValue]];
}

- (void)addFloat:(CGFloat)aValue{
    [self addObject:[NSNumber numberWithFloat:aValue]];
}

- (void)addPoint:(CGPoint)aValue{
    [self addObject:[NSValue valueWithCGPoint:aValue]];
}

- (void)addSize:(CGSize)aValue{
    [self addObject:[NSNumber valueWithCGSize:aValue]];
}

- (void)addRect:(CGRect)aValue{
    [self addObject:[NSNumber valueWithCGRect:aValue]];
}

- (void)insertBool:(BOOL)aValue atIndex:(NSUInteger)index{
    [self insertObject:[NSNumber numberWithBool:aValue] atIndex:index];
}

- (void)insertInteger:(NSInteger)aValue atIndex:(NSUInteger)index{
    [self insertObject:[NSNumber numberWithInteger:aValue] atIndex:index];
}

- (void)insertFloat:(CGFloat)aValue atIndex:(NSUInteger)index{
    [self insertObject:[NSNumber numberWithFloat:aValue] atIndex:index];
}

- (void)insertPoint:(CGPoint)aValue atIndex:(NSUInteger)index{
    [self insertObject:[NSValue valueWithCGPoint:aValue] atIndex:index];
}

- (void)insertSize:(CGSize)aValue atIndex:(NSUInteger)index{
    [self insertObject:[NSValue valueWithCGSize:aValue] atIndex:index];
}

- (void)insertRect:(CGRect)aValue atIndex:(NSUInteger)index{
    [self insertObject:[NSValue valueWithCGRect:aValue] atIndex:index];
}

@end