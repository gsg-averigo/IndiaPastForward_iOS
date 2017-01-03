//
//  UIImageView+Extension.m
//  Utilities
//
//  Created by Harish Kishenchand on 11/30/12.
//  Copyright (c) 2012 harish. All rights reserved.
//

#import "UIImageView+Extension.h"
#import "UIView+Frame.h"


#define ACTIVITY_INDICATOR_TAG 1038
#define PROGRESS_INDICATOR_TAG 1039

@implementation UIImageView (Extension)

Connection *connection;
UIImage *saveBackObject;

#pragma mark -
#pragma mark Initialization

- (id)initWithImageFromUrl:(NSURL *)url{
    self = [super init];
    if(self){
        [self loadImageFromUrl:url];
    }
    return self;
}

- (id)initWithImageFromUrl:(NSURL *)url showProgressIndicator:(BOOL)showsProgressIndicator{
    self = [super init];
    if(self){
        [self loadImageFromUrl:url showProgressIndicator:showsProgressIndicator];
    }
    return self;
}

- (void)loadImageFromUrl:(NSURL *)url{
    [self loadImageFromUrl:url showProgressIndicator:NO];
}

- (void)loadImageFromUrl:(NSURL *)url showProgressIndicator:(BOOL)showsProgressIndicator{
    connection = [[Connection alloc] initWithUrl:url];
    connection.connectionDelegate = (id<ConnectionDelegate>)self;
    connection.connectionPriority = ConnectionPriorityLow;
    [[ConnectionManager defaultManager] addConnection:connection];
    
    if(showsProgressIndicator){
        [self showActivityIndicator];
        [self showProgressPercentage];
    }
}

- (void)loadImageFromUrl:(NSURL *)url showProgressIndicator:(BOOL)showsProgressIndicator saveBackObject:(id)object{
    connection = [[Connection alloc] initWithUrl:url];
    connection.connectionDelegate = (id<ConnectionDelegate>)self;
    connection.connectionPriority = ConnectionPriorityLow;
    [[ConnectionManager defaultManager] addConnection:connection];
    
    if(showsProgressIndicator){
        [self showActivityIndicator];
        [self showProgressPercentage];
    }
}

#pragma mark -
#pragma mark UrlConnectionDelegate methods

- (void)connection:(Connection *)connection didReceiveData:(id)data{
    [self hideActivityIndicator];
    [self hideProgressPercentage];
    if([data isKindOfClass:[UIImage class]]){
        self.image = (UIImage *)data;
    }
}

- (void)connection:(Connection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes{
    UILabel *progressIndicator = (UILabel *)[self viewWithTag:PROGRESS_INDICATOR_TAG];
    if(progressIndicator){
        int percentage = ceil(((double)totalBytesWritten/ (double)expectedTotalBytes) * 100);
        [progressIndicator setText:[NSString stringWithFormat:@"%d%%",percentage]];
    }
}

- (void)connection:(Connection *)connection didFailWithError:(NSError *)error{
    [self hideActivityIndicator];
    [self hideProgressPercentage];
}


#pragma mark -
#pragma mark private methods

- (void)showActivityIndicator{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] init];
    [activityIndicator setTag:ACTIVITY_INDICATOR_TAG];
    [activityIndicator setAutoresizingMask:[self UIViewAutoresizingFlexibleAllMargin]];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setSize:CGSizeMake(24, 24)];
    [activityIndicator setCenter:CGPointMake(self.centerX, self.centerY)];
    [activityIndicator startAnimating];
    [self addSubview:activityIndicator];
}

- (void)showProgressPercentage{
    UILabel *progressIndicator = [[UILabel alloc] init];
    [progressIndicator setTag:PROGRESS_INDICATOR_TAG];
    [progressIndicator setAutoresizingMask:[self UIViewAutoresizingFlexibleAllMargin]];
    [progressIndicator setBackgroundColor:[UIColor clearColor]];
    [progressIndicator setTextColor:[UIColor grayColor]];
    [progressIndicator setTextAlignment:NSTextAlignmentCenter];
    [progressIndicator setFont:[UIFont systemFontOfSize:12]];
    [progressIndicator setSize:CGSizeMake(36, 18)];
    [progressIndicator alignCenterX];
    
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self viewWithTag:ACTIVITY_INDICATOR_TAG];
    [progressIndicator setTop:activityIndicator.bottom];
    [self addSubview:progressIndicator];
}

- (void)hideActivityIndicator{
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self viewWithTag:ACTIVITY_INDICATOR_TAG];
    if(activityIndicator){
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
    }
}

- (void)hideProgressPercentage{
    UILabel *progressIndicator = (UILabel *)[self viewWithTag:PROGRESS_INDICATOR_TAG];
    if(progressIndicator){
        [progressIndicator removeFromSuperview];
        progressIndicator = nil;
    }
}

- (UIViewAutoresizing)UIViewAutoresizingFlexibleAllMargin{
    return UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

@end
