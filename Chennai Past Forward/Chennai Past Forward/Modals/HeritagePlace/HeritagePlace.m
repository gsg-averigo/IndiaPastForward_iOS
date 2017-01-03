//
//  HeritagePlace.m
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "HeritagePlace.h"

@implementation HeritagePlace

+ (HeritagePlace *)objectFromDictionary:(NSDictionary *)dictionary
{
    HeritagePlace *heritagePlace = [[HeritagePlace alloc] init];
    
    for (NSString *key in dictionary.allKeys)
    {
        if([key isEqualToString:@"Name"])
        {
            heritagePlace.name = [dictionary objectForKey:key];
            NSLog(@"the addition Vlaue %@", heritagePlace.name);
            
            
        }
        else if([key isEqualToString:@"BuildingNo"])
        {
            heritagePlace.buildingNo = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"StreetName"])
        {
            heritagePlace.city = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"Location"])
        {
            heritagePlace.location = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"City"])
        {
            heritagePlace.city = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"Pincode"])
        {
            heritagePlace.pincode = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"Landmarks"])
        {
            heritagePlace.landmarks = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"Latitude"])
        {
            heritagePlace.latitude = [[dictionary objectForKey:key] floatValue];
        }
        else if([key isEqualToString:@"Longitude"])
        {
            heritagePlace.longitude = [[dictionary objectForKey:key] floatValue];
            
          
            
        }
        else if([key isEqualToString:@"Category"])
        {
            heritagePlace.category = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"HeritageBuildingInfoGUID"])
        {
            heritagePlace.heritagebuildinginfoguid = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"Description"]){
            heritagePlace.hp_description = [dictionary objectForKey:key];
            heritagePlace.hp_description = [heritagePlace.hp_description stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
            heritagePlace.hp_description = [heritagePlace.hp_description stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
            heritagePlace.hp_description = [heritagePlace.hp_description stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
            heritagePlace.hp_description = [heritagePlace.hp_description stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
            heritagePlace.hp_description = [heritagePlace.hp_description stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        }
        else if([key isEqualToString:@"AliasStreetNames"]){
            heritagePlace.aliasStreetNames = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"AlternativeNames"]){
            heritagePlace.alternativeNames = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"Photo"])
        {
            heritagePlace.image =[dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"SearchTags"]){
            heritagePlace.searchTags = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"ThumbnailPhoto"]){
            heritagePlace.thumbnailphoto = [dictionary objectForKey:key];
        }
        else if ([key isEqualToString:@"TypeID"])
        {
          heritagePlace.typeids=[dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"TextFile"]){
            heritagePlace.textFile = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"AudioFile"]){
            heritagePlace.audioFile = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"VideoFile"]){
            heritagePlace.videoFile = [dictionary objectForKey:key];
        }
        else if([key isEqualToString:@"Distance"]){
            heritagePlace.distance = [[dictionary objectForKey:key]floatValue];
        }
    }
    return heritagePlace;
}

@end
