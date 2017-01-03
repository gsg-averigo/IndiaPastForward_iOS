//
//  NearByLocation.m
//  Chennai Past Forward
//
//  Created by BTS on 02/02/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import "NearByLocation.h"

@implementation NearByLocation
+(NearByLocation *)objectFromDictionary:(NSDictionary *)dictionary
{
    NearByLocation *nearPlace = [[NearByLocation alloc] init];
    nearPlace.types=[[NSMutableArray alloc]init];
    for (NSString *key in dictionary.allKeys)
    {
        if([key isEqualToString:@"name"])
        {
            nearPlace.name = [dictionary objectForKey:key];
            NSLog(@"the addition Vlaue %@", nearPlace.name);
        }
        else if([key isEqualToString:@"vicinity"])
        {
            nearPlace.vicinity = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"id"])
        {
            nearPlace.idvalue = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"url"])
        {
            nearPlace.url = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"icon"])
        {
            nearPlace.icon = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"lattitude"])
        {
            nearPlace.latitude = [[dictionary objectForKey:key] floatValue];
        }
        else if([key isEqualToString:@"longitude"])
        {
            nearPlace.longitude = [[dictionary objectForKey:key] floatValue];
        }
        else if([key isEqualToString:@"types"])
        {
            NSArray *typearray=[dictionary objectForKey:key];
            
            for(int i=0;i<typearray.count;i++)
            {
        
                [nearPlace.types addObject:[typearray objectAtIndex:i]];
            }
         }
    }
    return nearPlace;
}
@end
