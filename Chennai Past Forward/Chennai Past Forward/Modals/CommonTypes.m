//
//  CommonTypes.m
//  Chennai Past Forward
//
//  Created by BTS on 20/07/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import "CommonTypes.h"

@implementation CommonTypes
+(CommonTypes *)objectFromDictionary:(NSDictionary *)dictionary
{
    CommonTypes *commontypes = [[CommonTypes alloc] init];
    
    for (NSString *key in dictionary.allKeys)
    {
        if([key isEqualToString:@"TypesCode"])
        {
            commontypes.TypesCode = [dictionary objectForKey:key];
            NSLog(@"the addition Vlaue %@", commontypes.TypesCode);
        }
        else if([key isEqualToString:@"Type"])
        {
            commontypes.Type=[dictionary objectForKey:key];
        }
    }
    return commontypes;
}

@end
