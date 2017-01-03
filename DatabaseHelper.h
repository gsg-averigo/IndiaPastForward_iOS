//
//  DatabaseHelper.h
//  DatabaseDemo
//
//  Created by Ravi Dixit on 01/02/13.
//  Copyright (c) 2013 Ravi Dixit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseHelper : NSObject
{
    sqlite3 *databaseReference;
}

- (id)init;

//Copies the database from the Project bundle to the document directory
- (BOOL)copyDatabaseFromBundletoDocumentDirectory;

// gets the location of the database present in the document directory
- (NSString*)documentDirectoryDatabaseLocation;

// creates the database instance
- (void)createDatabaseInstance;

// checks if any previous db connection is open before firing a new query
//and if the connection is open then closes it
- (void)closeanyOpenConnection;

//Insert userdetails
- (BOOL)insertUser:(NSString*)emailid andUserName:(NSString *)name
               andDeviceID:(NSString*)deviceid andPassword:(NSString*)password;


// inserts the new walks record
-(BOOL)insertWalkList:(NSString*)walkguid andFranchiseID:(NSString *)franchiseID
        andWalkName:(NSString*)walkname andWalkDistance:(NSString*)walkdistance andWalkDescription:(NSString*)walkdescription andPhoto:(NSString*)photoImage andWalkArea:(NSString*)walkarea andWalkAudio:(NSString*)audiofile andWalkCost:(NSString*)walkcost andWalkDate:(NSString*)availabledate andWalkStatus:(NSString*)walkstatus andFranchiseName:(NSString*)franchisename;

// inserts walkpoilists
- (BOOL)insertWalkPoiList:(NSString*)walkguid andSequenceNo:(NSString *)sequenceno
           andPOIGuid:(NSString*)poiguid;

//insert walkpurcashehistory
- (BOOL)insertPurchaseHistory:(NSString*)purcasheguid andWalkGUID:(NSString *)walkguid
andEmailID:(NSString*)emailid andDateOfWalk:(NSString*)dow  andPurchasedDate:(NSString*)purchaseddate
andPurchaseConfirmation:(NSString*)puchasedconfirmation;


//insert pointofinterest
- (BOOL)insertPointOfInterest:(NSString*)poiguid andFranchiseID:(NSString *)franchiseID
           andPoiName:(NSString*)poiname andDescription:(NSString*)description andAddress:(NSString*)address andCity:(NSString*)city andPinCode:(NSString*)pincode andState:(NSString*)state andLatitude:(NSString*)latitude andLongitude:(NSString*)longitude andLandmarks:(NSString*)landmarks andTags:(NSString*)tags andPhoto:(NSString*)photoImage andThumbnail:(NSString*)thumbnail andAudio:(NSString*)audio andVideoFile:(NSString*)video;


//Insert AttractionsnearPOI
- (BOOL)insertAttractionnearPOI:(NSString*)advertisementguid andSequenceNo:(NSString *)sequenceno
                     andPOIGuid:(NSString*)poiguid;



//Insert Attractions
- (BOOL)insertAttractions:(NSString*)advertisementguid andName:(NSString *)name
           andFranchiseID:(NSString*)franchiseid andDescription:(NSString*)description andAddress:(NSString*)address andPhoto:(NSString*)photoImage andThumbnail:(NSString*)thumbnail andFromDate:(NSString*)fromdate andToDate:(NSString*)todate andAdvertisementStatus:(NSString*)advertisementstatus;


//Insert Directions
-(BOOL)insertPoiDirections:(NSString*)poiguid andSequenceNo:(NSString*)seqno andDescription:(NSString*)descrption;

- (BOOL)insertPoiPhotos:(NSString *)poiguid andPhotos:(NSString *)photos andDate:(NSString *)mod_date;



//check login details when offline
-(NSMutableArray*)getLoginDetails:(NSString *)email andpass:(NSString*)password;

// get all walks list downloaded
- (NSMutableArray*)getAllWalks:(NSString *)emailid;

// gets the walkslist record using walkguid
- (NSMutableArray*)getWalkListsByWalkGuid:(NSString*)walkguid;

//get poi based on walkguid
- (NSMutableArray*)getPOI:(NSString*)walkguid;

//get Attraction based on poiguid
- (NSMutableArray*)getAllAttractions:(NSString*)poiguid;


-(NSMutableArray*)getallDirections:(NSString*)poiguid;

//get Array Of Poiguid based on walkguid
- (NSMutableArray*)poiguid:(NSString *)walkguid;
-(NSMutableArray*)getPhotos:(NSString *) poiguid;


//get purchased walk history
- (NSMutableArray*)getPurchasedWalks:(NSString *)emailid;

//check whether walk date has been completed already..
- (NSString *)checkwalk;

//check poi 
- (NSString*)checkpoi:(NSString*)walkguid;


// Delete the walk based on walkguid
- (BOOL)deletewalk:(NSString*)walkguid;

// Delete Purcashed walk based on walkguid
- (BOOL)deletepurcashedwalk:(NSString*)walkguid;

// Delete walkpoi based on walkguid
- (BOOL)deletewalkpoi:(NSString*)walkguid;

//delete poi
-(BOOL)deletepoi:(NSString*)walkguid;

//delete directions
-(BOOL)deletedirection:(NSString*)walkguid;

//delete attractions
- (BOOL)deleteattractions:(NSString*)walkguid;

//delete attracyionnearpoi
- (BOOL)deleteattractionsnearpoi:(NSString*)walkguid;

//All Records for chennai past forward
- (NSMutableArray*)getAllRecords;

////Delete Table
-(BOOL)deleteHeritage:(NSString*)walkguid;


////Create New Table

- (BOOL)createNewTable;

//insert values

-(BOOL)deleteheritageplaces;

-(BOOL)insert:(NSString*)guid andName:(NSString*)name andAlternative:(NSString*)alternative andCategory:(NSString*)category andDistance:(NSString*)distance andDescription:(NSString*)description andLattitude:(NSString*)lattitude andLongitide:(NSString*)longitude andPincode:(NSString*)pincode andPhoto:(NSString*)photo andThumbnailPhoto:(NSString*)thumbnailPhoto andLocation:(NSString*)location;
@end

