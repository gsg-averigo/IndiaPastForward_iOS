 //
//  UIView+Frame.m
//  cpf
//
//  Created by Harish Kishenchand on 01/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)left{
    return self.frame.origin.x;
}

- (CGFloat)right{
    return self.left + self.width;
}

- (CGFloat)top{
    return self.frame.origin.y;
}

- (CGFloat)bottom{
    return self.top + self.height;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (CGSize)size{
    return self.frame.size;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (CGFloat)centerY{
    return self.center.y;
}


- (void)setLeft:(CGFloat)left{
    [self setOrigin:CGPointMake(left, self.top)];
}

- (void)setRight:(CGFloat)right{
    [self setLeft:right - self.width];
}

- (void)setTop:(CGFloat)top{
    [self setOrigin:CGPointMake(self.left, top)];
}

- (void)setBottom:(CGFloat)bottom{
    [self setTop:bottom - self.height];
}

- (void)setWidth:(CGFloat)width{
    [self setSize:CGSizeMake(width, self.height)];
}

- (void)setHeight:(CGFloat)height{
    [self setSize:CGSizeMake(self.width, height)];
}

- (void)setOrigin:(CGPoint)origin{
    [self setFrame:CGRectMake(origin.x, origin.y, self.width, self.height)];
}

- (void)setSize:(CGSize)size
{
    [self setFrame:CGRectMake(self.left, self.top, size.width, size.height)];

}

- (void)setCenterX:(CGFloat)centerX{
    [self setCenter:CGPointMake(centerX, self.centerY)];
}

- (void)setCenterY:(CGFloat)centerY{
    [self setCenter:CGPointMake(self.centerX, centerY)];
}


- (void)alignLeft{
    [self setLeft:0];
}

- (void)alignRight{
    [self setRight:self.superview.right];
}

- (void)alignTop{
    [self setTop:0];
}

- (void)alignBottom{
    [self setBottom:self.superview.bottom];
}

- (void)alignTopLeft{
    [self setOrigin:CGPointMake(0, 0)];
}

- (void)alignTopRight{
    [self setOrigin:CGPointMake(self.superview.right - self.width, 0)];
}

- (void)alignBottomLeft{
    [self setOrigin:CGPointMake(0, self.superview.bottom - self.height)];
}

- (void)alignBottomRight{
    [self setOrigin:CGPointMake(self.superview.right - self.width, self.superview.bottom - self.height)];
}

- (void)alignCenter{
    [self setCenter:CGPointMake(self.superview.centerX, self.superview.centerY)];
}

- (void)alignCenterX{
    [self setCenterX:self.superview.centerX];
}

- (void)alignCenterY{
    [self setCenterY:self.superview.centerY];
}

@end