//
//  CommonTypes.h
//  Chennai Past Forward
//
//  Created by BTS on 20/07/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTypes : NSObject

@property(strong,nonatomic)NSString *TypesCode;
@property(strong,nonatomic)NSString *Type;

+ (CommonTypes *)objectFromDictionary:(NSDictionary *)dictionary;

@end
