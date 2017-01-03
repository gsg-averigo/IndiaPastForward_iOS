//
//  Request.h
//  cpf
//
//  Created by Harish Kishenchand on 24/09/13.
//  Copyright (c) 2013 geval6. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ConnectionManager.h"

#define ROOT_URL @"http://www.pastforward.in/"
#define ROOT_URL1 @"http://10.0.0.28/chennaipastforward/"

@interface Request : NSObject
+ (void)makeRequestWithIdentifier:(ConnectionIdentifier)identifier parameters:(NSDictionary *)parameters delegate:(id)delegate;
+ (NSString *)UDID;
@end
