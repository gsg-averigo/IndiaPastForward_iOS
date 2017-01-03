//
//  UIView+Frame.h
//  cpf
//
//  Created by Harish Kishenchand on 01/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
- (CGFloat)left;
- (CGFloat)right;
- (CGFloat)top;
- (CGFloat)bottom;
- (CGFloat)width;
- (CGFloat)height;
- (CGPoint)origin;
- (CGSize)size;
- (CGFloat)centerX;
- (CGFloat)centerY;

- (void)setLeft:(CGFloat)left;
- (void)setRight:(CGFloat)right;
- (void)setTop:(CGFloat)top;
- (void)setBottom:(CGFloat)bottom;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;

- (void)alignLeft;
- (void)alignRight;
- (void)alignTop;
- (void)alignBottom;
- (void)alignTopLeft;
- (void)alignTopRight;
- (void)alignBottomLeft;
- (void)alignBottomRight;
- (void)alignCenter;
- (void)alignCenterX;
- (void)alignCenterY;
@end
