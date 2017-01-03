//
//  UIView+Shadow.m
//  cpf
//
//  Created by Harish Kishenchand on 04/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "UIView+Shadow.h"
#define SHADOW_COLOR [UIColor blackColor]
#define SHADOW_SIZE 10.0
#define SHADOW_OPACITY 0.25
#define SHADOW_RADIUS 25.0

@implementation UIView (Shadow)

- (void)setShadowWithColor:(UIColor *)color Offset:(CGSize)offset Opacity:(CGFloat)opacity Radius:(CGFloat)radius{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
}

- (void)setLeftShadow{
    [self setShadowWithColor:SHADOW_COLOR Offset:CGSizeMake(-SHADOW_SIZE, 0) Opacity:SHADOW_OPACITY Radius:SHADOW_RADIUS];
}

- (void)setRightShadow{
    [self setShadowWithColor:SHADOW_COLOR Offset:CGSizeMake(SHADOW_SIZE, 0) Opacity:SHADOW_OPACITY Radius:SHADOW_RADIUS];
}

- (void)setTopShadow{
    [self setShadowWithColor:SHADOW_COLOR Offset:CGSizeMake(0, -SHADOW_SIZE) Opacity:SHADOW_OPACITY Radius:SHADOW_RADIUS];
}

- (void)setBottomShadow{
    [self setShadowWithColor:SHADOW_COLOR Offset:CGSizeMake(0, SHADOW_SIZE) Opacity:SHADOW_OPACITY Radius:SHADOW_RADIUS];
}

- (void)setTopLeftShadow{
    [self setShadowWithColor:SHADOW_COLOR Offset:CGSizeMake(-SHADOW_SIZE, -SHADOW_SIZE) Opacity:SHADOW_OPACITY Radius:SHADOW_RADIUS];
}

- (void)setTopRightShadow{
    [self setShadowWithColor:SHADOW_COLOR Offset:CGSizeMake(SHADOW_SIZE, -SHADOW_SIZE) Opacity:SHADOW_OPACITY Radius:SHADOW_RADIUS];
}

- (void)setBottomLeftShadow{
    [self setShadowWithColor:SHADOW_COLOR Offset:CGSizeMake(-SHADOW_SIZE, SHADOW_SIZE) Opacity:SHADOW_OPACITY Radius:SHADOW_RADIUS];
}

- (void)setBottomRightShadow{
    [self setShadowWithColor:SHADOW_COLOR Offset:CGSizeMake(SHADOW_SIZE, SHADOW_SIZE) Opacity:SHADOW_OPACITY Radius:SHADOW_RADIUS];
}

- (void)setCenterShadow{
    [self setShadowWithColor:SHADOW_COLOR Offset:CGSizeMake(0, 0) Opacity:SHADOW_OPACITY * 2.0 Radius:SHADOW_RADIUS * 2.5];
}

- (void)setCenterShadow2{
    [self setShadowWithColor:SHADOW_COLOR Offset:CGSizeMake(0, 0) Opacity:SHADOW_OPACITY * 2.0 Radius:SHADOW_RADIUS];
}

- (void)setBottomShadow2{
    [self setShadowWithColor:SHADOW_COLOR Offset:CGSizeMake(0, SHADOW_SIZE) Opacity:SHADOW_OPACITY Radius:SHADOW_RADIUS * 2.5];
}

- (void)setTopShadow2{
    [self setShadowWithColor:SHADOW_COLOR Offset:CGSizeMake(0, -SHADOW_SIZE) Opacity:SHADOW_OPACITY Radius:SHADOW_RADIUS];
}

- (void)setNoShadow{
    [self setShadowWithColor:[UIColor clearColor] Offset:CGSizeMake(0, 0) Opacity:0 Radius:0];
}

@end
