//
//  NSMutableDictionary+Extension.h
//  Utilities
//
//  Created by Harish Kishenchand on 30/11/12.
//  Copyright (c) 2012 harish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+Extension.h"

@interface NSMutableDictionary (Extension)
- (void)setBool:(BOOL)aValue forKey:(NSString *)aKey;
- (void)setInteger:(NSInteger)aValue forKey:(NSString *)aKey;
- (void)setFloat:(CGFloat)aValue forKey:(NSString *)aKey;
- (void)setPoint:(CGPoint)aValue forKey:(NSString *)aKey;
- (void)setSize:(CGSize)aValue forKey:(NSString *)aKey;
- (void)setRect:(CGRect)aValue forKey:(NSString *)aKey;
@end
