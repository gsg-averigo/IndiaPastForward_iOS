//
//  UIView+Shadow.h
//  cpf
//
//  Created by Harish Kishenchand on 04/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Shadow)
- (void)setShadowWithColor:(UIColor *)color Offset:(CGSize)offset Opacity:(CGFloat)opacity Radius:(CGFloat)radius;
- (void)setLeftShadow;
- (void)setRightShadow;
- (void)setTopShadow;
- (void)setBottomShadow;
- (void)setTopLeftShadow;
- (void)setTopRightShadow;
- (void)setBottomLeftShadow;
- (void)setBottomRightShadow;
- (void)setCenterShadow;
@end
