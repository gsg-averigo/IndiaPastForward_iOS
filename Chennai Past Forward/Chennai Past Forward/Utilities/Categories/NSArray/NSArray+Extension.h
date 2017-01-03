//
//  NSArray+Extension.h
//  Utilities
//
//  Created by Harish Kishenchand on 30/11/12.
//  Copyright (c) 2012 harish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extension)
- (BOOL)boolAtIndex:(NSUInteger)index;
- (NSInteger)integerAtIndex:(NSUInteger)index;
- (CGFloat)floatAtIndex:(NSUInteger)index;
- (CGPoint)pointAtIndex:(NSUInteger)index;
- (CGSize)sizeAtIndex:(NSUInteger)index;
- (CGRect)rectAtIndex:(NSUInteger)index;
@end
