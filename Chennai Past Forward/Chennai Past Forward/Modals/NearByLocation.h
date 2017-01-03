//
//  NearByLocation.h
//  Chennai Past Forward
//
//  Created by BTS on 02/02/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearByLocation : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *idvalue;
@property (strong, nonatomic) NSString *vicinity;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSMutableArray  *types;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;

+ (NearByLocation *)objectFromDictionary:(NSDictionary *)dictionary;
@end
