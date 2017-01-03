//
//  CalloutAnnotation.m
//
//  Created by Robert Ryan on 4/2/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/

#import "CalloutAnnotation.h"
#import "CustomAnnotation.h"

@interface CalloutAnnotation ()
@property (nonatomic, weak) id<MKAnnotation> annotation;
@end

@implementation CalloutAnnotation

- (instancetype)initForAnnotation:(id<MKAnnotation>)annotation
{
    self = [super init];
    if (self) {
        _annotation = annotation;
    }
    return self;
}

- (NSString *)title
{
    return _annotation.title;
}

- (NSString *)subtitle
{
    return _annotation.title;
}

- (CLLocationCoordinate2D)coordinate
{
    return _annotation.coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    [_annotation setCoordinate:newCoordinate];
}

@end
