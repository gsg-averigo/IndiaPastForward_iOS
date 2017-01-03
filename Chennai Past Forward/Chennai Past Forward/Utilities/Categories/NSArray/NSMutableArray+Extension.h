//
//  NSMutableArray+Extension.h
//  Utilities
//
//  Created by Harish Kishenchand on 30/11/12.
//  Copyright (c) 2012 harish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+Extension.h"

@interface NSMutableArray (Extension)
- (void)addBool:(BOOL)aValue;
- (void)addInteger:(NSInteger)aValue;
- (void)addFloat:(CGFloat)aValue;
- (void)addPoint:(CGPoint)aValue;
- (void)addSize:(CGSize)aValue;
- (void)addRect:(CGRect)aValue;
- (void)insertBool:(BOOL)aValue atIndex:(NSUInteger)index;
- (void)insertInteger:(NSInteger)aValue atIndex:(NSUInteger)index;
- (void)insertFloat:(CGFloat)aValue atIndex:(NSUInteger)index;
- (void)insertPoint:(CGPoint)aValue atIndex:(NSUInteger)index;
- (void)insertSize:(CGSize)aValue atIndex:(NSUInteger)index;
- (void)insertRect:(CGRect)aValue atIndex:(NSUInteger)index;
@end
