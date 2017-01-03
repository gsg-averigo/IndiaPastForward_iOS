//
//  Offer.m
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "Offer.h"

@implementation Offer
+ (Offer *)objectFromDictionary:(NSDictionary *)dictionary{
    Offer *offer = [[Offer alloc] init];
    for (NSString *key in dictionary.allKeys) {
        if([key isEqualToString:@"OfferTitle"]){
            offer.title = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"OfferDescription"]){
            offer.offerDescription = [dictionary objectForKey:key];
            offer.offerDescription = [offer.offerDescription stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
            offer.offerDescription = [offer.offerDescription stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
            offer.offerDescription = [offer.offerDescription stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
            offer.offerDescription = [offer.offerDescription stringByReplacingOccurrencesOfString:@"&lt;"   withString:@"<"];
            offer.offerDescription = [offer.offerDescription stringByReplacingOccurrencesOfString:@"&gt;"   withString:@">"];
        }
       else if([key isEqualToString:@"EnableWalk"]){
            offer.enablewalk = [dictionary objectForKey:key];
        }
       else if([key isEqualToString:@"count"]){
           offer.count = [dictionary objectForKey:key];
       }
        else if([key isEqualToString:@"OfferedBy"]){
            offer.offeredBy = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"OffersGUID"]){
            offer.offerGUID = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"Photo"]){
            offer.imageString = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"ValidFrom"]){
            offer.validFrom = [NSDate dateFromString:[dictionary objectForKey:key]];
        }
        else if([key isEqualToString:@"ValidTo"]){
            offer.validUpto = [NSDate dateFromString:[dictionary objectForKey:key]];
        }
    }
    return offer;
}

@end
