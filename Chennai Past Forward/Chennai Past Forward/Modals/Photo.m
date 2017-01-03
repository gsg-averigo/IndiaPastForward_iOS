//
//  Photo.m
//  Chennai Past Forward
//
//  Created by BTS on 9/9/15.
//  Copyright (c) 2015 Harish. All rights reserved.
//

#import "Photo.h"

@implementation Photo

+ (Photo *)objectFromDictionary:(NSDictionary *)dictionary
{
    Photo *photo= [[Photo alloc] init];
    
    for (NSString *key in dictionary.allKeys)
    {
        if([key isEqualToString:@"MediaFile"])
        {
            photo.name = [dictionary objectForKey:key];
            
            NSLog(@"the Photo Name %@",  photo.name);
        }
        else if([key isEqualToString:@"HeritageBuildingInfoGUID"])
        {
            photo.guid = [dictionary objectForKey:key];
        }
    }
    return photo;
}


@end
