//
//  Photo.h
//  Chennai Past Forward
//
//  Created by BTS on 9/9/15.
//  Copyright (c) 2015 Harish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject
@property (strong, nonatomic) NSString *guid;
@property (strong, nonatomic) NSString *name;
+ (Photo *)objectFromDictionary:(NSDictionary *)dictionary;
@end
