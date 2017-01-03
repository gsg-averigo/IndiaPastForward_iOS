//
//  CustomIndicator.m
//  Kiosh
//
//  Created by Muthu on 04/10/14.
//  Copyright (c) 2014 CIPL253-IOS. All rights reserved.
//

#import "CustomIndicator.h"

#define MAX_HEIGHT  90
#define MAX_WIDTH   90

@implementation CustomIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIView *myview = [[UIView alloc]initWithFrame:frame];
        [myview setBackgroundColor:[UIColor blackColor]];
        myview.layer.cornerRadius = 8.0;
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityView setFrame:CGRectMake(27, 23, 40, 40)];
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, myview.frame.size.width, 21)];
        [loadingLabel setBackgroundColor:[UIColor clearColor]];
        [loadingLabel setTextColor:[UIColor whiteColor]];
        [loadingLabel setText:@"Loading..."];
        [loadingLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        [myview addSubview:activityView];
        [myview addSubview:loadingLabel];
        [self addSubview:myview];
        
    }
    return self;
}

+ (id)sharedCustomIndicator {
    
    static CustomIndicator *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareInstance = [[self alloc] initWithFrame:CGRectMake(0, 0, MAX_WIDTH, MAX_HEIGHT)];
    });
    
    return shareInstance;
}

- (void)startLoadAnimation:(id)controller
{
    UIViewController *controllerObj = (UIViewController *)controller;
    [controllerObj.view addSubview:self];
    
    int xPos = [[UIScreen mainScreen] bounds].size.width/2 - MAX_WIDTH/2;
    int yPos = [[UIScreen mainScreen] bounds].size.height/2 - MAX_HEIGHT/2;
    
    [self setFrame:CGRectMake(xPos, yPos, MAX_WIDTH, MAX_HEIGHT)];
    
    [controllerObj.view setUserInteractionEnabled:FALSE];
    
    [activityView startAnimating];
}

-(void)stopLoadAnimation:(id)controller
{
    if([activityView isAnimating])
        [activityView stopAnimating];
    
    UIViewController *controllerObj = (UIViewController *)controller;
    [controllerObj.view setUserInteractionEnabled:TRUE];
    
    if([self isDescendantOfView:controllerObj.view])
    {
        [self removeFromSuperview];
    }
}

@end