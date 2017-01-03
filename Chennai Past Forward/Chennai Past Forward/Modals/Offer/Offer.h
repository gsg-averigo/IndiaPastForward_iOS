//
//  Offer.h
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offer : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *offeredBy;
@property (strong, nonatomic) NSString *offerGUID;
@property (strong, nonatomic) NSString *offerDescription;
@property (strong, nonatomic) NSString *enablewalk;
@property (strong, nonatomic) NSString *imageString;
@property (strong, nonatomic) NSString *count;
@property (strong, nonatomic) NSDate *validFrom;
@property (strong, nonatomic) NSDate *validUpto;
@property (strong, nonatomic) UIImage *image;
+ (Offer *)objectFromDictionary:(NSDictionary *)dictionary;
@end