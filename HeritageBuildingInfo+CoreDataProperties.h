//
//  HeritageBuildingInfo+CoreDataProperties.h
//  Chennai Past Forward
//
//  Created by BTS on 25/01/16.
//  Copyright © 2016 Harish. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HeritageBuildingInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface HeritageBuildingInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *distance;
@property (nullable, nonatomic, retain) NSString *heritagebuildinginfoguid;
@property (nullable, nonatomic, retain) NSString *hp_description;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *pincode;
@property (nullable, nonatomic, retain) NSData   *profileimage;
@property (nullable, nonatomic, retain) NSString *thumbnailphoto;
@property (nullable, nonatomic, retain) NSString *typeids;

@end

NS_ASSUME_NONNULL_END
