//
//  CompareImage.m
//  Chennai Past Forward
//
//  Created by BTS on 28/01/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import "CompareImage.h"

@implementation CompareImage

#define RETURN_HSV(h, s, v) {HSV.H = h; HSV.S = s; HSV.V = v; return HSV;}

#define RETURN_RGB(r, g, b) {RGB.R = r; RGB.G = g; RGB.B = b; return RGB;}

@end
