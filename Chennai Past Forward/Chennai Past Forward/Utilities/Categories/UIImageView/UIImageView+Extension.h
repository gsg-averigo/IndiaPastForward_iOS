//
//  UIImageView+Extension.h
//  Utilities
//
//  Created by Harish Kishenchand on 11/30/12.
//  Copyright (c) 2012 harish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"

@class Product;
@interface UIImageView (Extension)

- (id)initWithImageFromUrl:(NSURL *)url;
- (id)initWithImageFromUrl:(NSURL *)url
     showProgressIndicator:(BOOL)showsProgressIndicator;

- (void)loadImageFromUrl:(NSURL *)url;
- (void)loadImageFromUrl:(NSURL *)url
   showProgressIndicator:(BOOL)showsProgressIndicator;

- (void)loadImageFromUrl:(NSURL *)url
   showProgressIndicator:(BOOL)showsProgressIndicator
          saveBackObject:(id)object;

@end