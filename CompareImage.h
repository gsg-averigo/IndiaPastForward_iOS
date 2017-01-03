//
//  CompareImage.h
//  Chennai Past Forward
//
//  Created by BTS on 28/01/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    CGFloat h;
    CGFloat s;
    CGFloat v;
} COLOR_HSV;

typedef struct {
    CGFloat r;
    CGFloat g;
    CGFloat b;
} COLOR_RGB;

typedef struct {
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
} COLOR_RGBA;
@interface CompareImage : NSObject

@end
