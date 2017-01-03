//
//  HeritagePlace.h
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeritagePlace : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *buildingNo;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *streetName;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *pincode;
@property (strong, nonatomic) NSString *landmarks;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *heritagebuildinginfoguid;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *hp_description;
@property (strong, nonatomic) NSString *aliasStreetNames;
@property (strong, nonatomic) NSString *alternativeNames;
@property (strong, nonatomic) NSString *photo;
@property (strong, nonatomic) NSString *searchTags;
@property (strong, nonatomic) NSString *thumbnailphoto;
@property (strong, nonatomic) NSString *textFile;
@property (strong, nonatomic) NSString *audioFile;
@property (strong, nonatomic) NSString *videoFile;
@property (strong, nonatomic) NSData *photodata;
//@property (strong, nonatomic) UIImage *thumbnailimage;
@property (strong, nonatomic) NSString *typeids;
@property (nonatomic) CGFloat distance;
+ (HeritagePlace *)objectFromDictionary:(NSDictionary *)dictionary;
@end
