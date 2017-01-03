//
//  NSDictionary+Extension.h
//  Utilities
//
//  Created by Harish Kishenchand on 30/11/12.
//  Copyright (c) 2012 harish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)
- (BOOL)containsKey:(NSString *)aKey;
- (BOOL)boolForKey:(NSString *)aKey;
- (NSInteger)integerForKey:(NSString *)aKey;
- (CGFloat)floatForKey:(NSString *)aKey;
- (CGPoint)pointForKey:(NSString *)aKey;
- (CGSize)sizeForKey:(NSString *)aKey;
- (CGRect)rectForKey:(NSString *)aKey;
@end
