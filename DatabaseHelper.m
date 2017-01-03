//
//  DatabaseHelper.m
//  DatabaseDemo
//
//  Created by Ravi Dixit on 01/02/13.
//  Copyright (c) 2013 Ravi Dixit. All rights reserved.
//

#import "DatabaseHelper.h"
#import "Request.h"

@implementation DatabaseHelper

- (id)init
{
    [self createDatabaseInstance];
    return self;
}


//Copies the database from the Project bundle to the document directory
- (BOOL)copyDatabaseFromBundletoDocumentDirectory
{
    // If sqlite file does not exists at the document dir then get it from bundle and copy to doc directory
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self documentDirectoryDatabaseLocation]])
    {
        
        NSString *bundlePathofDatabase = [[NSBundle mainBundle]pathForResource:@"CPF" ofType:@"sqlite"];
//        NSString *dbFilePath=[NSHomeDirectory stringByAppendingPathComponent:@"mysqlite.sqlite"];
        
        if (bundlePathofDatabase.length!=0)
        {
            NSString *docdirLocation = [self documentDirectoryDatabaseLocation];
            
            // it should return YES which indicates that the file is copied
            return [[NSFileManager defaultManager] copyItemAtPath:bundlePathofDatabase toPath:docdirLocation error:nil];
        }
        
        // This means that your file is not copied in the document directory
        return NO;
    }
    else
    {
        return YES;
    }
}

// gets the location of the database present in the document directory
- (NSString*)documentDirectoryDatabaseLocation
{
    NSArray *documentDirectoryFolderLocation = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"Documents directory location %@",documentDirectoryFolderLocation);
    
    return [[documentDirectoryFolderLocation objectAtIndex:0] stringByAppendingPathComponent:@"CPF.sqlite"];
}

// creates the database instance at document directory
- (void)createDatabaseInstance
{
    
    if([self copyDatabaseFromBundletoDocumentDirectory])
    {
         NSLog(@"DB copied in doc dir");
    }
    else
    {
         NSLog(@"DB copying failed");
    }
}

// checks if any previous db connection is open before firing a new query
//and if the connection is open then closes it

- (void)closeanyOpenConnection
{
    if(sqlite3_open([[self documentDirectoryDatabaseLocation]UTF8String],&databaseReference)!= SQLITE_OK)
	{
		sqlite3_close(databaseReference);
	}
}

//insert into user details


- (BOOL)insertPoiPhotos:(NSString *)poiguid andPhotos:(NSString *)photos andDate:(NSString *)mod_date
{
    if (poiguid.length!=0 && photos.length!=0)
    {
        // checking for any previously open connection which was not closed
        [self closeanyOpenConnection];
        
        // preparing my sqlite query
        const char *sqliteQuery = "insert into cw_photos (`POIGUID`, `Photo`, `LastModified`) values(?,?,?)";
        
        sqlite3_stmt *sqlstatement = nil;
        
        if (sqlite3_prepare_v2(databaseReference, sqliteQuery, -1, &sqlstatement, NULL)==SQLITE_OK )
        {
            sqlite3_bind_text(sqlstatement, 1, [poiguid UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 2, [photos UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 3, [mod_date UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_step(sqlstatement);
            
            // clearing the sql statement
            sqlite3_finalize(sqlstatement);
            //closing the database after the query execution
            sqlite3_close(databaseReference);
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
    

}


- (BOOL)insertUser:(NSString*)emailid andUserName:(NSString *)name
       andDeviceID:(NSString*)deviceid andPassword:(NSString*)password
{
    if (emailid.length!=0 && deviceid.length!=0)
    {
        // checking for any previously open connection which was not closed
        [self closeanyOpenConnection];
        
        // preparing my sqlite query
        const char *sqliteQuery = "insert into cw_userinitregistration (`EmailID`, `UserName`, `DeviceID`, `Password`) values(?,?,?,?)";
        
        sqlite3_stmt *sqlstatement = nil;
        
        if (sqlite3_prepare_v2(databaseReference, sqliteQuery, -1, &sqlstatement, NULL)==SQLITE_OK )
        {
            sqlite3_bind_text(sqlstatement, 1, [emailid UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 2, [name UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 3, [deviceid UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 4, [password UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_step(sqlstatement);
            
            // clearing the sql statement
            sqlite3_finalize(sqlstatement);
            //closing the database after the query execution
            sqlite3_close(databaseReference);
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;

}

// insert into  walks record
- (BOOL)insertWalkList:(NSString*)walkguid andFranchiseID:(NSString *)franchiseID
           andWalkName:(NSString*)walkname andWalkDistance:(NSString*)walkdistance andWalkDescription:(NSString*)walkdescription andPhoto:(NSString*)photoImage andWalkArea:(NSString*)walkarea andWalkAudio:(NSString*)audiofile andWalkCost:(NSString*)walkcost andWalkDate:(NSString*)availabledate andWalkStatus:(NSString*)walkstatus andFranchiseName:(NSString*)franchisename

{
//    NSString *type = [[NSString alloc]init];
    NSString *exp_date = [[NSString alloc]init];
    NSString *expquery = [[NSString alloc]init];
    NSLog(@"CWalk Name:%@",walkname);
    NSLog(@"CWalk GUID:%@",walkguid);
    if (walkguid.length!=0 && walkname.length!=0)
    {
        // checking for any previously open connection which was not closed
        [self closeanyOpenConnection];
        
        
        
        if([walkcost isEqualToString:@"Free"])
        {
        expquery=[NSString stringWithFormat:@"SELECT date('now','+7 day')"];
        }
        else
        {
        expquery=[NSString stringWithFormat:@"SELECT date('now','+1 day')"];
        }
        
        const char *expQuery = [expquery UTF8String];
        sqlite3_stmt *exptstatement = nil;
        
        if (sqlite3_prepare_v2(databaseReference, expQuery, -1, &exptstatement , NULL)==SQLITE_OK) {
            
            // declaring a dictionary so that response can be saved in KVC
//            NSString *dict = [[NSString alloc]init];
            
            while (sqlite3_step(exptstatement) == SQLITE_ROW)
            {
                
                char* guidChar = (char*)sqlite3_column_text(exptstatement, 0);
                exp_date = [NSString stringWithUTF8String:guidChar];
            }
            
        }

        
        
        // preparing my sqlite query
        const char *sqliteQuery = "insert into cw_walkslist (`WalkGUID`, `FranchiseID`, `WalkName`, `WalkDistance`, `Description`, `Photo`, `Area`, `AudioFile`, `WalkCost`, `AvailableDate`, `WalkStatus`,'FranchiseName','ExpDate') values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
        
        sqlite3_stmt *sqlstatement = nil;
        
//        NSString *string = [[NSString alloc] initWithUTF8String:sqliteQuery];

        
        if (sqlite3_prepare_v2(databaseReference, sqliteQuery, -1, &sqlstatement, NULL)==SQLITE_OK )
        {
            sqlite3_bind_text(sqlstatement, 1, [walkguid UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 2, [franchiseID UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(sqlstatement, 3, [walkname UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(sqlstatement, 4, [walkdistance UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(sqlstatement, 5, [walkdescription UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 6, [photoImage UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(sqlstatement, 7, [walkarea UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(sqlstatement, 8, [audiofile UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(sqlstatement, 9, [walkcost UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(sqlstatement, 10, [availabledate UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(sqlstatement, 11, [walkstatus UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 12, [franchisename UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 13, [exp_date UTF8String], -1,  SQLITE_TRANSIENT);
            // executes the sql statement with the data you need to insert in the db
            
            
            
            sqlite3_step(sqlstatement);
            // clearing the sql statement
            sqlite3_finalize(sqlstatement);
            //closing the database after the query execution
            sqlite3_close(databaseReference);
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}

//insert into purchase history table

- (BOOL)insertPurchaseHistory:(NSString*)purcasheguid andWalkGUID:(NSString *)walkguid
    andEmailID:(NSString*)emailid andDateOfWalk:(NSString*)dow  andPurchasedDate:(NSString*)purchaseddate
      andPurchaseConfirmation:(NSString*)puchasedconfirmation
{
    if (purcasheguid.length!=0 && walkguid.length!=0)
    {
        // checking for any previously open connection which was not closed
        [self closeanyOpenConnection];
        
        // preparing my sqlite query
        const char *sqliteQuery = "insert into cw_walkpurchasehistory (`PurchaseGUID`, `WalkGUID`, `EmailID`, `DateOfWalk`, `PurchasedDate`, `PurchaseConfirmation`) values(?,?,?,?,?,?)";
        
        sqlite3_stmt *sqlstatement = nil;
        
        if (sqlite3_prepare_v2(databaseReference, sqliteQuery, -1, &sqlstatement, NULL)==SQLITE_OK )
        {
            sqlite3_bind_text(sqlstatement, 1, [purcasheguid UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 2, [walkguid UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 3, [emailid UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 4, [dow UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 5, [purchaseddate UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 6, [puchasedconfirmation UTF8String], -1,  SQLITE_TRANSIENT);
            // executes the sql statement with the data you need to insert in the db
            sqlite3_step(sqlstatement);
            
            // clearing the sql statement
            sqlite3_finalize(sqlstatement);
            //closing the database after the query execution
            sqlite3_close(databaseReference);
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;

}
//insert into walkpoilist
- (BOOL)insertWalkPoiList:(NSString*)walkguid andSequenceNo:(NSString *)sequenceno
               andPOIGuid:(NSString*)poiguid
{
    
    if (walkguid.length!=0 && poiguid.length!=0)
    {
        // checking for any previously open connection which was not closed
        [self closeanyOpenConnection];
        
        // preparing my sqlite query
        const char *sqliteQuery = "insert into cw_walkpoilist (`WalkGUID`, `SequenceNo`, `POIGUID`) values(?,?,?)";
        
        sqlite3_stmt *sqlstatement = nil;
        
        if (sqlite3_prepare_v2(databaseReference, sqliteQuery, -1, &sqlstatement, NULL)==SQLITE_OK )
        {
            NSString * seqno=[NSString stringWithFormat:@"%@",sequenceno];
            NSLog(@"seqno:%@",seqno);
            sqlite3_bind_text(sqlstatement, 1, [walkguid UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 2, [seqno UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 3, [poiguid UTF8String], -1,  SQLITE_TRANSIENT);
            // executes the sql statement with the data you need to insert in the db
            sqlite3_step(sqlstatement);
            
            // clearing the sql statement
            sqlite3_finalize(sqlstatement);
            //closing the database after the query execution
            sqlite3_close(databaseReference);
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
    
}

//insert itno point of interest
- (BOOL)insertPointOfInterest:(NSString*)poiguid andFranchiseID:(NSString *)franchiseID
                   andPoiName:(NSString*)poiname andDescription:(NSString*)description andAddress:(NSString*)address andCity:(NSString*)city andPinCode:(NSString*)pincode andState:(NSString*)state andLatitude:(NSString*)latitude andLongitude:(NSString*)longitude andLandmarks:(NSString*)landmarks andTags:(NSString*)tags andPhoto:(NSString*)photoImage andThumbnail:(NSString*)thumbnail andAudio:(NSString*)audio andVideoFile:(NSString*)video
{

    if (poiguid.length!=0 && franchiseID.length!=0)
    {
 
        // checking for any previously open connection which was not closed
        [self closeanyOpenConnection];
        
        // preparing my sqlite query
        const char *sqliteQuery = "insert into cw_pointofinterests (`POIGUID`, `FranchiseID`, `POIName`,'Description','Address','City','PinCode','State','Latitude','Longitude','Landmarks','Tags','Photo','Thumbnail','AudioFile','VideoFile') values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
 
        sqlite3_stmt *sqlstatement = nil;
        
        if (sqlite3_prepare_v2(databaseReference, sqliteQuery, -1, &sqlstatement, NULL)==SQLITE_OK )
        {
            sqlite3_bind_text(sqlstatement, 1, [poiguid UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 2, [franchiseID UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 3, [poiname UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 4, [description UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(sqlstatement,5, [address UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(sqlstatement, 6, [city UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 7, [pincode UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 8, [state UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 9, [latitude UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 10, [longitude UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 11, [landmarks UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 12, [tags UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 13, [photoImage UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 14, [thumbnail UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(sqlstatement, 15, [audio UTF8String], -1,  SQLITE_TRANSIENT);
             sqlite3_bind_text(sqlstatement, 16, [video UTF8String], -1,  SQLITE_TRANSIENT);
            // executes the sql statement with the data you need to insert in the db
            sqlite3_step(sqlstatement);
            
            // clearing the sql statement
            sqlite3_finalize(sqlstatement);
            //closing the database after the query execution
            sqlite3_close(databaseReference);
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
    
}

//Insert AttractionsnearPOI
- (BOOL)insertAttractionnearPOI:(NSString*)advertisementguid andSequenceNo:(NSString *)sequenceno
                     andPOIGuid:(NSString*)poiguid
{
    if (advertisementguid.length!=0 && poiguid.length!=0)
    {
        // checking for any previously open connection which was not closed
        [self closeanyOpenConnection];
        
        // preparing my sqlite query
        const char *sqliteQuery = "insert into cw_attractionsnearpoi (`AdvertisementGUID`, `SequenceNo`, `POIGUID`) values(?,?,?)";
        
        sqlite3_stmt *sqlstatement = nil;
        
        if (sqlite3_prepare_v2(databaseReference, sqliteQuery, -1, &sqlstatement, NULL)==SQLITE_OK )
        {
            sqlite3_bind_text(sqlstatement, 1, [advertisementguid UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 2, [sequenceno UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 3, [poiguid UTF8String], -1,  SQLITE_TRANSIENT);
            // executes the sql statement with the data you need to insert in the db
            sqlite3_step(sqlstatement);
            
            // clearing the sql statement
            sqlite3_finalize(sqlstatement);
            //closing the database after the query execution
            sqlite3_close(databaseReference);
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}


//Insert Attractions

-(BOOL)insertAttractions:(NSString*)advertisementguid andName:(NSString *)name
          andFranchiseID:(NSString*)franchiseid andDescription:(NSString*)description andAddress:(NSString*)address andPhoto:(NSString*)photoImage andThumbnail:(NSString*)thumbnail andFromDate:(NSString*)fromdate andToDate:(NSString*)todate andAdvertisementStatus:(NSString*)advertisementstatus
{
    
    if (advertisementguid.length!=0 && franchiseid.length!=0)
    {
        // checking for any previously open connection which was not closed
        [self closeanyOpenConnection];
        
        // preparing my sqlite query
        const char *sqliteQuery = "insert into cw_advertisements (`AdvertisementGUID`, `AdvertisementName`,`FranchiseID`,'Description','Address','Photo','Thumbnail','EffectiveFromDate','EffectiveToDate','AdvertisementStatus') values(?,?,?,?,?,?,?,?,?,?)";
        
        sqlite3_stmt *sqlstatement = nil;
        
        if (sqlite3_prepare_v2(databaseReference, sqliteQuery, -1, &sqlstatement, NULL)==SQLITE_OK )
        {
            sqlite3_bind_text(sqlstatement, 1, [advertisementguid UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 2, [name UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 3, [franchiseid UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 4, [description UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement,5, [address UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement,6, [photoImage UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 7, [thumbnail UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 8, [fromdate UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 9, [todate UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 10, [advertisementstatus UTF8String], -1,  SQLITE_TRANSIENT);
           
            // executes the sql statement with the data you need to insert in the db
            sqlite3_step(sqlstatement);
            
            // clearing the sql statement
            sqlite3_finalize(sqlstatement);
            //closing the database after the query execution
            sqlite3_close(databaseReference);
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;

    
}






//Insert Directions
- (BOOL)insertPoiDirections:(NSString *)poiguid andSequenceNo:(NSString *)seqno andDescription:(NSString *)descrption
{
    if (poiguid.length!=0)
    {
        // checking for any previously open connection which was not closed
        [self closeanyOpenConnection];
        
        // preparing my sqlite query
        const char *sqliteQuery = "insert into cw_directions (`POIGUID`, `SequenceNo`, `Description`) values(?,?,?)";
        
        sqlite3_stmt *sqlstatement = nil;
        
        if (sqlite3_prepare_v2(databaseReference, sqliteQuery, -1, &sqlstatement, NULL)==SQLITE_OK )
        {
            sqlite3_bind_text(sqlstatement, 1, [poiguid UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 2, [seqno UTF8String], -1,  SQLITE_TRANSIENT);
            sqlite3_bind_text(sqlstatement, 3, [descrption UTF8String], -1,  SQLITE_TRANSIENT);
            // executes the sql statement with the data you need to insert in the db
            sqlite3_step(sqlstatement);
            
            // clearing the sql statement
            sqlite3_finalize(sqlstatement);
            //closing the database after the query execution
            sqlite3_close(databaseReference);
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return NO;
}




-(NSMutableArray*)getLoginDetails:(NSString *)email andpass:(NSString*)password
{
    NSMutableArray *recordSet = [[NSMutableArray alloc]init];
    [self closeanyOpenConnection];
    
    // Query to fetch the emp name and images from the database
    NSString *fetchQuery = [NSString stringWithFormat:@"select * from cw_userinitregistration where EmailID='%@' and Password COLLATE nocase='%@'",email,password];
    
    const char *selectQuery = [fetchQuery UTF8String];
    sqlite3_stmt *sqlstatement = nil;
    
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            
            char* emailChar = (char*)sqlite3_column_text(sqlstatement, 0);
            NSString *emailStr = [NSString stringWithUTF8String:emailChar];
            [dict setValue:emailStr forKey:@"EmailID"];
            
            char* nameChar = (char*)sqlite3_column_text(sqlstatement, 1);
            NSString *nameStr = [NSString stringWithUTF8String:nameChar];
            [dict setValue:nameStr forKey:@"UserName"];
            
            char* deviceChar = (char*)sqlite3_column_text(sqlstatement, 2);
            NSString *deviceStr = [NSString stringWithUTF8String:deviceChar];
            [dict setValue:deviceStr forKey:@"DeviceID"];
            
            char* passwordChar = (char*)sqlite3_column_text(sqlstatement, 3);
            NSString *passStr = [NSString stringWithUTF8String:passwordChar];
            [dict setValue:passStr forKey:@"Password"];
            
            
            // saving the record set in a MutableArray
            [recordSet addObject:dict];
            
            // clearing off the dictionary to make sure that it does not contain any garbage data
            dict = nil;
            
            // re- initalizing the dictionary for next record
            dict = [[NSMutableDictionary alloc]init];
        }
        
        // once all the fetching is one clearing off the dict variable for good.
        dict = nil;
        
    }
    
    
    return  recordSet;
}

- (NSMutableArray*)getWalkListsByWalkGuid:(NSString*)walkguid
{
    NSMutableArray *recordSet = [[NSMutableArray alloc]init];
    [self closeanyOpenConnection];
    
    // Query to fetch the emp name and images from the database
    NSString *fetchQuery = [NSString stringWithFormat:@"select * from cw_walkslist where WalkGUID='%@'",walkguid];
    
    
    const char *selectQuery = [fetchQuery UTF8String];
    sqlite3_stmt *sqlstatement = nil;
    
    
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            
            char* guidChar = (char*)sqlite3_column_text(sqlstatement, 0);
            NSString *guidStr = [NSString stringWithUTF8String:guidChar];
            [dict setValue:guidStr forKey:@"WalkGUID"];
            
            char* fidChar = (char*)sqlite3_column_text(sqlstatement, 1);
            NSString *fidStr = [NSString stringWithUTF8String:fidChar];
            [dict setValue:fidStr forKey:@"FranchiseID"];
            
            char* nameChar = (char*)sqlite3_column_text(sqlstatement, 2);
            NSString *nameStr = [NSString stringWithUTF8String:nameChar];
            [dict setValue:nameStr forKey:@"WalkName"];
            
            char* distanceChar = (char*)sqlite3_column_text(sqlstatement, 3);
            NSString *distStr = [NSString stringWithUTF8String:distanceChar];
            [dict setValue:distStr forKey:@"WalkDistance"];
            
            char* descChar = (char*)sqlite3_column_text(sqlstatement, 4);
            NSString *descStr = [NSString stringWithUTF8String:descChar];
            [dict setValue:descStr forKey:@"Description"];

            char* photoChar = (char*)sqlite3_column_text(sqlstatement, 5);
            NSString *photoStr = [NSString stringWithUTF8String:photoChar];
            [dict setValue:photoStr forKey:@"Photo"];
            
            char* areaChar = (char*)sqlite3_column_text(sqlstatement, 6);
            NSString *areaStr = [NSString stringWithUTF8String:areaChar];
            [dict setValue:areaStr forKey:@"Area"];
            
            char* audioChar = (char*)sqlite3_column_text(sqlstatement, 7);
            NSString *audioStr = [NSString stringWithUTF8String:audioChar];
            [dict setValue:audioStr forKey:@"AudioFile"];
            
            char* costChar = (char*)sqlite3_column_text(sqlstatement, 8);
            NSString *costStr = [NSString stringWithUTF8String:costChar];
            [dict setValue:costStr forKey:@"WalkCost"];
            
            char* dateChar = (char*)sqlite3_column_text(sqlstatement, 9);
            NSString *dateStr = [NSString stringWithUTF8String:dateChar];
            [dict setValue:dateStr forKey:@"AvailableDate"];
            
            char* statusChar = (char*)sqlite3_column_text(sqlstatement, 10);
            NSString *statusStr = [NSString stringWithUTF8String:statusChar];
            [dict setValue:statusStr forKey:@"WalkStatus"];
            
            // saving the record set in a MutableArray
            [recordSet addObject:dict];
            

            
            // clearing off the dictionary to make sure that it does not contain any garbage data
            dict = nil;
            
            // re- initalizing the dictionary for next record
            dict = [[NSMutableDictionary alloc]init];
        }
        
        // once all the fetching is one clearing off the dict variable for good.
        dict = nil;
        
    }
    
    return  recordSet;

    
}
- (NSMutableArray*)getAllAttractions:(NSString*)poiguid
{

    NSMutableArray *recordSet = [[NSMutableArray alloc]init];
    [self closeanyOpenConnection];
    
    // Query to fetch the emp name and images from the database
    NSString *fetchQuery = [NSString stringWithFormat:@"select POI.AdvertisementGUID, POI.AdvertisementName,POI.Description,POI.Photo from cw_attractionsnearpoi POIL left join cw_advertisements POI on POI.AdvertisementGUID = POIL.AdvertisementGUID where ((POIL.POIGUID = '%@') AND POI.AdvertisementStatus='A' AND (DATE('now') between POI.EffectiveFromDate AND POI.EffectiveToDate)) Order by POIL.sequenceno",poiguid];
   
    const char *selectQuery = [fetchQuery UTF8String];
    sqlite3_stmt *sqlstatement = nil;
    
    
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            
            char* guidChar = (char*)sqlite3_column_text(sqlstatement, 0);
            NSString *guidStr = [NSString stringWithUTF8String:guidChar];
            [dict setValue:guidStr forKey:@"AdvertisementGUID"];
            
            char* nameChar = (char*)sqlite3_column_text(sqlstatement, 1);
            NSString *nameStr = [NSString stringWithUTF8String:nameChar];
            [dict setValue:nameStr forKey:@"AdvertisementName"];
            

            char* descriptionChar = (char*)sqlite3_column_text(sqlstatement, 2);
            NSString *descStr = [NSString stringWithUTF8String:descriptionChar];
            [dict setValue:descStr forKey:@"Description"];
            
            char* photoChar = (char*)sqlite3_column_text(sqlstatement, 3);
            NSString *photoStr = [NSString stringWithUTF8String:photoChar];
            [dict setValue:photoStr forKey:@"Photo"];
 
            // saving the record set in a MutableArray
            [recordSet addObject:dict];
            
            // clearing off the dictionary to make sure that it does not contain any garbage data
            dict = nil;
            
            // re- initalizing the dictionary for next record
            dict = [[NSMutableDictionary alloc]init];
        }
        
        // once all the fetching is one clearing off the dict variable for good.
        dict = nil;
        
    }
    
    
    return  recordSet;
    
}



// get all walks list records downloaded

- (NSMutableArray*)getAllWalks:(NSString*)emailid
{
    NSMutableArray *recordSet = [[NSMutableArray alloc]init];
    [self closeanyOpenConnection];
    
   // const char *selectQuery = "select * from cw_walkslist";
   
    
    //temp change
    
    NSString *fetchQuery = [NSString stringWithFormat:@"SELECT WL .WalkGUID,WL.FranchiseID,WL .WalkName,WL.WalkDistance,WL.Description,WL.Photo,WL .Area,WL.AudioFile,WL .WalkCost,WL .AvailableDate,WL .WalkStatus,WL.FranchiseName,'N' as purchaseguid, 'N' as StartWalk FROM `cw_walkslist` WL  where  WL.WalkGUID Not in (Select WalkGUID FROM cw_walkpurchasehistory WHERE EmailID='%@')  and WL. AvailableDate<=date() union SELECT WL .WalkGUID ,WL.FranchiseID,WL .WalkName,WL.WalkDistance,WL .Description,WL .Photo,WL .Area,WL.AudioFile,WL .WalkCost,WL.AvailableDate,WL .WalkStatus,WL.FranchiseName,PH.PurchaseGUID as purchaseguid,CASE when (select date(PH.DateOfWalk))=date() then 'Y' else 'N' END StartWalk From cw_walkpurchasehistory PH left join cw_walkslist WL on WL.WalkGUID=PH.WalkGUID  WHERE EmailID='%@' and PH.DateOfWalk >=(select DateOfWalk from cw_walkpurchasehistory where WalkGUID= PH.WalkGUID and EmailID='%@' order by DateOfWalk desc limit 1)",emailid,emailid,emailid];
    
    
    
   /* NSString * fetchQuery=[NSString stringWithFormat:@"SELECT WalkGUID,FranchiseID,WalkName,WalkDistance,Description,Photo,Area,AudioFile,WalkCost,AvailableDate,WalkStatus,FranchiseName,'N' as purchaseguid, 'N' as StartWalk FROM `cw_walkslist` limit 1"];
    */
    
    NSLog(@"fetch query:%@",fetchQuery);
    const char *selectQuery = [fetchQuery UTF8String];
     sqlite3_stmt *sqlstatement = nil;
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            char* guidChar = (char*)sqlite3_column_text(sqlstatement, 0);
            NSString *guidStr = [NSString stringWithUTF8String:guidChar];
            [dict setValue:guidStr forKey:@"WalkGUID"];
            
            char* fidChar = (char*)sqlite3_column_text(sqlstatement, 1);
            NSString *fidStr = [NSString stringWithUTF8String:fidChar];
            [dict setValue:fidStr forKey:@"FranchiseID"];
            
            char* nameChar = (char*)sqlite3_column_text(sqlstatement, 2);
            NSString *nameStr = [NSString stringWithUTF8String:nameChar];
            [dict setValue:nameStr forKey:@"WalkName"];
            
            char* distanceChar = (char*)sqlite3_column_text(sqlstatement, 3);
            NSString *distStr = [NSString stringWithUTF8String:distanceChar];
            [dict setValue:distStr forKey:@"WalkDistance"];
            
            char* descChar = (char*)sqlite3_column_text(sqlstatement, 4);
            NSString *descStr = [NSString stringWithUTF8String:descChar];
            [dict setValue:descStr forKey:@"Description"];
            
            char* photoChar = (char*)sqlite3_column_text(sqlstatement, 5);
            NSString *photoStr = [NSString stringWithUTF8String:photoChar];
            [dict setValue:photoStr forKey:@"Photo"];
            
            char* areaChar = (char*)sqlite3_column_text(sqlstatement, 6);
            NSString *areaStr = [NSString stringWithUTF8String:areaChar];
            [dict setValue:areaStr forKey:@"Area"];
            
            char* audioChar = (char*)sqlite3_column_text(sqlstatement, 7);
            NSString *audioStr = [NSString stringWithUTF8String:audioChar];
            [dict setValue:audioStr forKey:@"AudioFile"];
            
            char* costChar = (char*)sqlite3_column_text(sqlstatement, 8);
            NSString *costStr = [NSString stringWithUTF8String:costChar];
            [dict setValue:costStr forKey:@"WalkCost"];
            
            char* dateChar = (char*)sqlite3_column_text(sqlstatement, 9);
            NSString *dateStr = [NSString stringWithUTF8String:dateChar];
            [dict setValue:dateStr forKey:@"AvailableDate"];
            
            char* statusChar = (char*)sqlite3_column_text(sqlstatement, 10);
            NSString *statusStr = [NSString stringWithUTF8String:statusChar];
            [dict setValue:statusStr forKey:@"WalkStatus"];
            
            char* franchisenameChar = (char*)sqlite3_column_text(sqlstatement, 11);
            NSString *franchisenameStr = [NSString stringWithUTF8String:franchisenameChar];
            [dict setValue:franchisenameStr forKey:@"FranchiseName"];
            
            char* purchaseguidChar = (char*)sqlite3_column_text(sqlstatement, 12);
            NSString *purchaseguidCharStr = [NSString stringWithUTF8String:purchaseguidChar];
            [dict setValue:purchaseguidCharStr forKey:@"purchaseguid"];
            
            char* startwalkChar = (char*)sqlite3_column_text(sqlstatement, 13);
            NSString *startwalkStr = [NSString stringWithUTF8String:startwalkChar];
            [dict setValue:startwalkStr forKey:@"StartWalk"];
            
            // saving the record set in a MutableArray
            [recordSet addObject:dict];
            
            // clearing off the dictionary to make sure that it does not contain any garbage data
            dict = nil;
            
            // re- initalizing the dictionary for next record
            dict = [[NSMutableDictionary alloc]init];
        }
        
        // once all the fetching is one clearing off the dict variable for good.
        dict = nil;
        
    }
    
    
    return  recordSet;
    
}

// get all walks list records downloaded

- (NSMutableArray*)getPOI:(NSString *)walkguid
{
    NSMutableArray *recordSet = [[NSMutableArray alloc]init];
    [self closeanyOpenConnection];
    
    NSString *fetchQuery = [NSString stringWithFormat:@"select POIL.sequenceno, POI.POIGUID, POI.POIName,POI.AudioFile, POI.Latitude,POI.Photo,POI.Longitude,POI.Description from cw_walkpoilist POIL left join cw_pointofinterests POI on POI.poiguid = POIL.poiguid where POIL.walkguid ='%@' Order by POIL.sequenceno",walkguid];
    
    const char *selectQuery = [fetchQuery UTF8String];
    
    sqlite3_stmt *sqlstatement = nil;
    
    
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            char* seqChar = (char*)sqlite3_column_text(sqlstatement, 0);
            NSString *seqStr = [NSString stringWithUTF8String:seqChar];
            [dict setValue:seqStr forKey:@"sequenceno"];
            
            char* guidChar = (char*)sqlite3_column_text(sqlstatement, 1);
            NSString *guidStr = [NSString stringWithUTF8String:guidChar];
            [dict setValue:guidStr forKey:@"POIGUID"];
            
            char* nameChar = (char*)sqlite3_column_text(sqlstatement, 2);
            NSString *nameStr = [NSString stringWithUTF8String:nameChar];
            [dict setValue:nameStr forKey:@"POIName"];
            
            char* audioChar = (char*)sqlite3_column_text(sqlstatement, 3);
            NSString *audioStr = [NSString stringWithUTF8String:audioChar];
            [dict setValue:audioStr forKey:@"AudioFile"];
            
            
            char* latitudeChar = (char*)sqlite3_column_text(sqlstatement, 4);
            NSString *latStr = [NSString stringWithUTF8String:latitudeChar];
            [dict setValue:latStr forKey:@"Latitude"];
            
            
            char* photoChar = (char*)sqlite3_column_text(sqlstatement, 5);
            NSString *photoStr = [NSString stringWithUTF8String:photoChar];
            [dict setValue:photoStr forKey:@"Photo"];
            
            char* longChar = (char*)sqlite3_column_text(sqlstatement, 6);
            NSString *longStr = [NSString stringWithUTF8String:longChar];
            [dict setValue:longStr forKey:@"Longitude"];
            
            char* descChar = (char*)sqlite3_column_text(sqlstatement, 7);
            NSString *descStr = [NSString stringWithUTF8String:descChar];
            [dict setValue:descStr forKey:@"Description"];
            
            // saving the record set in a MutableArray
            [recordSet addObject:dict];
            
            
            // clearing off the dictionary to make sure that it does not contain any garbage data
            dict = nil;
            
            // re- initalizing the dictionary for next record
            dict = [[NSMutableDictionary alloc]init];
        }
        
        // once all the fetching is one clearing off the dict variable for good.
        dict = nil;
        
    }
    
    
    return  recordSet;
}


// get all Purchased Walk records downloaded

- (NSMutableArray*)getPurchasedWalks:(NSString *)emailid
{
    NSMutableArray *recordSet = [[NSMutableArray alloc]init];
    [self closeanyOpenConnection];
    
    NSString *fetchQuery = [NSString stringWithFormat:@"SELECT WL.WalkGUID,WL.FranchiseID,WL .WalkName,WL.WalkDistance,WL.Description,WL.Photo,WL .Area,WL.AudioFile,WL .WalkCost,WL .AvailableDate,WL .WalkStatus,WL.FranchiseName,'N' as purchaseguid,CASE WHEN date(WP.DateOfWalk) = DATE('now') then 'Y' ELSE 'N' end  as StartWalk,WP.DateOfWalk as DateOfWalk  FROM `cw_walkslist` WL left Join `cw_walkpurchasehistory` WP on WP.WalkGUID = WL.WalkGUID where(WP.EmailID= '%@') ORDER BY `PurchasedDate` DESC",emailid];
    NSLog(@"%@",fetchQuery);
    const char *selectQuery = [fetchQuery UTF8String];
    sqlite3_stmt *sqlstatement = nil;
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            char* guidChar = (char*)sqlite3_column_text(sqlstatement, 0);
            NSString *guidStr = [NSString stringWithUTF8String:guidChar];
            [dict setValue:guidStr forKey:@"WalkGUID"];
            
            char* fidChar = (char*)sqlite3_column_text(sqlstatement, 1);
            NSString *fidStr = [NSString stringWithUTF8String:fidChar];
            [dict setValue:fidStr forKey:@"FranchiseID"];
            
            char* nameChar = (char*)sqlite3_column_text(sqlstatement, 2);
            NSString *nameStr = [NSString stringWithUTF8String:nameChar];
            [dict setValue:nameStr forKey:@"WalkName"];
            
            char* distanceChar = (char*)sqlite3_column_text(sqlstatement, 3);
            NSString *distStr = [NSString stringWithUTF8String:distanceChar];
            [dict setValue:distStr forKey:@"WalkDistance"];
            
            char* descChar = (char*)sqlite3_column_text(sqlstatement, 4);
            NSString *descStr = [NSString stringWithUTF8String:descChar];
            [dict setValue:descStr forKey:@"Description"];
            
            char* photoChar = (char*)sqlite3_column_text(sqlstatement, 5);
            NSString *photoStr = [NSString stringWithUTF8String:photoChar];
            [dict setValue:photoStr forKey:@"Photo"];
            
            char* areaChar = (char*)sqlite3_column_text(sqlstatement, 6);
            NSString *areaStr = [NSString stringWithUTF8String:areaChar];
            [dict setValue:areaStr forKey:@"Area"];
            
            char* audioChar = (char*)sqlite3_column_text(sqlstatement, 7);
            NSString *audioStr = [NSString stringWithUTF8String:audioChar];
            [dict setValue:audioStr forKey:@"AudioFile"];
            
            char* costChar = (char*)sqlite3_column_text(sqlstatement, 8);
            NSString *costStr = [NSString stringWithUTF8String:costChar];
            [dict setValue:costStr forKey:@"WalkCost"];
            
            char* dateChar = (char*)sqlite3_column_text(sqlstatement, 9);
            NSString *dateStr = [NSString stringWithUTF8String:dateChar];
            [dict setValue:dateStr forKey:@"AvailableDate"];
            
            char* statusChar = (char*)sqlite3_column_text(sqlstatement, 10);
            NSString *statusStr = [NSString stringWithUTF8String:statusChar];
            [dict setValue:statusStr forKey:@"WalkStatus"];
            
            char* franchisenameChar = (char*)sqlite3_column_text(sqlstatement, 11);
            NSString *franchisenameStr = [NSString stringWithUTF8String:franchisenameChar];
            [dict setValue:franchisenameStr forKey:@"FranchiseName"];
            
            char* purchaseguidChar = (char*)sqlite3_column_text(sqlstatement, 12);
            NSString *purchaseguidCharStr = [NSString stringWithUTF8String:purchaseguidChar];
            [dict setValue:purchaseguidCharStr forKey:@"purchaseguid"];
            
            char* startwalkChar = (char*)sqlite3_column_text(sqlstatement, 13);
            NSString *startwalkStr = [NSString stringWithUTF8String:startwalkChar];
            [dict setValue:startwalkStr forKey:@"StartWalk"];
            
            char* dowalkChar = (char*)sqlite3_column_text(sqlstatement, 14);
            NSString *dowStr = [NSString stringWithUTF8String:dowalkChar];
            [dict setValue:dowStr forKey:@"DateOfWalk"];
            
            
            
            // saving the record set in a MutableArray
            [recordSet addObject:dict];
            
            
            // clearing off the dictionary to make sure that it does not contain any garbage data
            dict = nil;
            
            // re- initalizing the dictionary for next record
            dict = [[NSMutableDictionary alloc]init];
        }
        
        // once all the fetching is one clearing off the dict variable for good.
        dict = nil;
        
    }
    
    
    return  recordSet;
    
}

//Array of POIGUID

- (NSMutableArray*)poiguid:(NSString *)walkguid
{
    NSMutableArray *recordSet = [[NSMutableArray alloc]init];
    [self closeanyOpenConnection];
    
    NSString *fetchQuery = [NSString stringWithFormat:@"SELECT POIGUID  FROM `cw_walkpoilist` where WalkGUID= '%@'",walkguid];
    NSLog(@"%@",fetchQuery);
    const char *selectQuery = [fetchQuery UTF8String];
    sqlite3_stmt *sqlstatement = nil;
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            char* guidChar = (char*)sqlite3_column_text(sqlstatement, 0);
            NSString *guidStr = [NSString stringWithUTF8String:guidChar];
            [dict setValue:guidStr forKey:@"POIGUID"];
            
            
            // saving the record set in a MutableArray
            [recordSet addObject:dict];
            
            
            // clearing off the dictionary to make sure that it does not contain any garbage data
            dict = nil;
            
            // re- initalizing the dictionary for next record
            dict = [[NSMutableDictionary alloc]init];
        }
        
        // once all the fetching is one clearing off the dict variable for good.
        dict = nil;
        
    }
    
    
    return  recordSet;
    
}

-(NSMutableArray*)getallDirections:(NSString *)poiguid
{
    NSMutableArray *recordSet = [[NSMutableArray alloc]init];
    [self closeanyOpenConnection];
    
    NSString *fetchQuery;
    fetchQuery=[NSString stringWithFormat:@"SELECT Description FROM `cw_directions` WHERE POIGUID='%@'",poiguid];
    
    NSLog(@"%@",fetchQuery);
    
    const char *selectQuery = [fetchQuery UTF8String];
    sqlite3_stmt *sqlstatement = nil;
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            char* descChar = (char*)sqlite3_column_text(sqlstatement, 0);
            NSString *descStr = [NSString stringWithUTF8String:descChar];
            [dict setValue:descStr forKey:@"Description"];
            
            // saving the record set in a MutableArray
            [recordSet addObject:dict];
            
            
            // clearing off the dictionary to make sure that it does not contain any garbage data
            dict = nil;
            
            // re- initalizing the dictionary for next record
            dict = [[NSMutableDictionary alloc]init];
        }
        
        // once all the fetching is one clearing off the dict variable for good.
        dict = nil;
        
    }
    
    
    return  recordSet;
    
}


-(NSMutableArray*)getPhotos:(NSString *) poiguid
{
    
    NSMutableArray *recordSet = [[NSMutableArray alloc]init];
    [self closeanyOpenConnection];
    
    NSString *fetchQuery;
    fetchQuery=[NSString stringWithFormat:@"SELECT Photo FROM `cw_photos` WHERE POIGUID='%@'",poiguid];
    
    NSLog(@"%@",fetchQuery);
    
    const char *selectQuery = [fetchQuery UTF8String];
    sqlite3_stmt *sqlstatement = nil;
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            char* descChar = (char*)sqlite3_column_text(sqlstatement, 0);
            NSString *descStr = [NSString stringWithUTF8String:descChar];
            [dict setValue:descStr forKey:@"Photo"];
            
            // saving the record set in a MutableArray
            [recordSet addObject:dict];
            
            
            // clearing off the dictionary to make sure that it does not contain any garbage data
            dict = nil;
            
            // re- initalizing the dictionary for next record
            dict = [[NSMutableDictionary alloc]init];
        }
        
        // once all the fetching is one clearing off the dict variable for good.
        dict = nil;
        
    }
    
    
    return  recordSet;
    
    
}

- (NSString*)checkwalk
{
    NSString *recordSet = [[NSString alloc]init];
    NSString *wcost = [[NSString alloc]init];
//    NSString *fetchQuery=[[NSString alloc]init];
    
    [self closeanyOpenConnection];
    
    NSString *costquery=[[NSString alloc]init];
    
    costquery=[NSString stringWithFormat:@"select WalkCost from cw_walkslist"];
    
    const char *costQuery = [costquery UTF8String];
    sqlite3_stmt *coststatement = nil;
    
    if (sqlite3_prepare_v2(databaseReference, costQuery, -1, &coststatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
//        NSString *dict = [[NSString alloc]init];
        
        while (sqlite3_step(coststatement) == SQLITE_ROW)
        {
            
            char* guidChar = (char*)sqlite3_column_text(coststatement, 0);
            wcost = [NSString stringWithUTF8String:guidChar];
        }
        
    }
    

     NSLog(@"walk cost:%@",wcost);
    
    NSString *fQuery=[[NSString alloc]init];
    
    if([wcost isEqualToString:@"Free"])
    {
         fQuery = [NSString stringWithFormat:@"select WalkGUID from cw_walkslist where ExpDate < DATE('now')"];
    }
    else
    {
       fQuery = [NSString stringWithFormat:@"select WalkGUID from cw_walkpurchasehistory where DateOfWalk <= DATE('now')"];
    }
    
   // NSLog(@"%@",fQuery);
    
    const char *selectQuery = [fQuery UTF8String];
    sqlite3_stmt *sqlstatement = nil;
    
    
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
//        NSString *dict = [[NSString alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            
            char* guidChar = (char*)sqlite3_column_text(sqlstatement, 0);
            recordSet = [NSString stringWithUTF8String:guidChar];
        }
        
    }
    
    return  recordSet;
    
}

- (NSString*)checkpoi:(NSString*)walkguid
{
    NSString *recordSet = [[NSString alloc]init];
    [self closeanyOpenConnection];
    
    // Query to fetch the emp name and images from the database
    NSString *fetchQuery = [NSString stringWithFormat:@"select POIGUID from cw_walkpoilist where WalkGUID='%@'",walkguid];
    
    const char *selectQuery = [fetchQuery UTF8String];
    sqlite3_stmt *sqlstatement = nil;
    
    
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK)
    {
        // declaring a dictionary so that response can be saved in KVC
//        NSString *dict = [[NSString alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            
            char* guidChar = (char*)sqlite3_column_text(sqlstatement, 0);
            recordSet = [NSString stringWithUTF8String:guidChar];
        }
        
    }
    
    return  recordSet;
    
}


- (BOOL)deletewalk:(NSString *)walkguid
{
    BOOL flag = NO ;
    
        NSString *sqliteQuery = [NSString stringWithFormat:@"Delete from cw_walkslist where WalkGUID = '%@'",walkguid];
    [self closeanyOpenConnection];
    
    sqlite3_stmt *sqlStatement = nil;
    if (sqlite3_prepare_v2(databaseReference, [sqliteQuery UTF8String], -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        sqlite3_step(sqlStatement);
        sqlite3_finalize(sqlStatement);
        sqlite3_close(databaseReference);
        flag = YES;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *dataPath = [NSString stringWithFormat:[documentsDirectory stringByAppendingPathComponent:@"/%@"],walkguid];
        
        NSError *error = nil;
        for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:&error]) {
            [[NSFileManager defaultManager] removeItemAtPath:[dataPath stringByAppendingPathComponent:file] error:&error];
        }
        
        [[NSFileManager defaultManager] removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:walkguid] error:&error];
        
        NSLog(@"walk has been deleted successfully..!!");
    }
    else
    {
        flag = NO;
    }
    
    return flag;
}


- (BOOL)deletepurcashedwalk:(NSString*)walkguid
{
    
    BOOL flag = NO ;
    
    NSString *sqliteQuery = [NSString stringWithFormat:@"Delete from cw_walkpurchasehistory where WalkGUID = '%@'",walkguid];
    [self closeanyOpenConnection];
    
    sqlite3_stmt *sqlStatement = nil;
    if (sqlite3_prepare_v2(databaseReference, [sqliteQuery UTF8String], -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        sqlite3_step(sqlStatement);
        sqlite3_finalize(sqlStatement);
        sqlite3_close(databaseReference);
        flag = YES;
        NSLog(@"walk purchase history has been deleted successfully..!!");
    }
    else
    {
        flag = NO;
    }
    
    return flag;
}


- (BOOL)deletewalkpoi:(NSString*)walkguid
{
    
    BOOL flag = NO ;
    
    NSString *sqliteQuery = [NSString stringWithFormat:@"Delete from cw_walkpoilist where WalkGUID = '%@'",walkguid];
    [self closeanyOpenConnection];
    
    sqlite3_stmt *sqlStatement = nil;
    if (sqlite3_prepare_v2(databaseReference, [sqliteQuery UTF8String], -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        sqlite3_step(sqlStatement);
        sqlite3_finalize(sqlStatement);
        sqlite3_close(databaseReference);
        flag = YES;
         NSLog(@"walk poi list has been deleted successfully..!!");
    }
    else
    {
        flag = NO;
    }
    
    return flag;
}

-(BOOL)deletepoi:(NSString*)walkguid
{
    BOOL flag = NO ;
    
    NSString *sqliteQuery = [NSString stringWithFormat:@"DELETE FROM cw_pointofinterests WHERE POIGUID IN ( SELECT POIGUID FROM cw_walkpoilist WHERE WalkGUID = '%@' )",walkguid];
    [self closeanyOpenConnection];
    
    sqlite3_stmt *sqlStatement = nil;
    if (sqlite3_prepare_v2(databaseReference, [sqliteQuery UTF8String], -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        sqlite3_step(sqlStatement);
        sqlite3_finalize(sqlStatement);
        sqlite3_close(databaseReference);
        flag = YES;
        NSLog(@"poi has been deleted successfully..!!");
    }
    else
    {
        flag = NO;
    }
    
    return flag;
}

-(BOOL)deletedirection:(NSString *)walkguid
{
    BOOL flag = NO ;
    
    NSString *sqliteQuery = [NSString stringWithFormat:@"Delete FROM cw_directions WHERE POIGUID IN (SELECT distinct POIGUID FROM  cw_walkpoilist  WHERE WalkGUID = '%@')",walkguid];
    [self closeanyOpenConnection];
    
    sqlite3_stmt *sqlStatement = nil;
    if (sqlite3_prepare_v2(databaseReference, [sqliteQuery UTF8String], -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        sqlite3_step(sqlStatement);
        sqlite3_finalize(sqlStatement);
        sqlite3_close(databaseReference);
        flag = YES;
        NSLog(@"advertisements has been deleted successfully..!!");
    }
    else
    {
        flag = NO;
    }
    
    return flag;
}


-(BOOL)deleteattractions:(NSString*)walkguid
{
    BOOL flag = NO ;
    
    NSString *sqliteQuery = [NSString stringWithFormat:@"Delete FROM cw_advertisements WHERE AdvertisementGUID IN (SELECT distinct `AdvertisementGUID` FROM cw_attractionsnearpoi WHERE POIGUID IN (SELECT POIGUID FROM cw_walkpoilist WHERE WalkGUID = '%@'))",walkguid];
    [self closeanyOpenConnection];
    
    sqlite3_stmt *sqlStatement = nil;
    if (sqlite3_prepare_v2(databaseReference, [sqliteQuery UTF8String], -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        sqlite3_step(sqlStatement);
        sqlite3_finalize(sqlStatement);
        sqlite3_close(databaseReference);
        flag = YES;
         NSLog(@"advertisements has been deleted successfully..!!");
    }
    else
    {
        flag = NO;
    }
    
    return flag;
}
-(BOOL)deleteattractionsnearpoi:(NSString*)walkguid
{
    BOOL flag = NO ;
    
    NSString *sqliteQuery = [NSString stringWithFormat:@"Delete FROM cw_attractionsnearpoi WHERE POIGUID IN (SELECT POIGUID FROM cw_walkpoilist WHERE WalkGUID = '%@')",walkguid];
    [self closeanyOpenConnection];
    
    sqlite3_stmt *sqlStatement = nil;
    if (sqlite3_prepare_v2(databaseReference, [sqliteQuery UTF8String], -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        sqlite3_step(sqlStatement);
        sqlite3_finalize(sqlStatement);
        sqlite3_close(databaseReference);
        flag = YES;
        NSLog(@"attractionnearpoi has been deleted successfully..!!");
    }
    else
    {
        flag = NO;
    }
    
    return flag;
}


#pragma mark - CPF


- (NSMutableArray*)getAllRecords
{
    NSMutableArray *recordSet = [[NSMutableArray alloc]init];
    [self closeanyOpenConnection];
    
    // const char *selectQuery = "select * from cw_walkslist";
    
    
    //temp change
    
    NSString *fetchQuery = [NSString stringWithFormat:@"SELECT * FROM HERITAGE"];

    
    NSLog(@"fetch query:%@",fetchQuery);
    const char *selectQuery = [fetchQuery UTF8String];
    sqlite3_stmt *sqlstatement = nil;
    if (sqlite3_prepare_v2(databaseReference, selectQuery, -1, &sqlstatement , NULL)==SQLITE_OK) {
        
        // declaring a dictionary so that response can be saved in KVC
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        while (sqlite3_step(sqlstatement) == SQLITE_ROW)
        {
            char* guidChar = (char*)sqlite3_column_text(sqlstatement, 0);
            NSString *guidStr = [NSString stringWithUTF8String:guidChar];
            [dict setValue:guidStr forKey:@"heritagebuildinginfoguid"];
            NSLog(@"guid:%@",guidStr);
            
            char* nameChar = (char*)sqlite3_column_text(sqlstatement, 1);
            NSString *nameStr = [NSString stringWithUTF8String:nameChar];
            [dict setValue:nameStr forKey:@"name"];
             NSLog(@"nameStr:%@",nameStr);
            
            char* descChar = (char*)sqlite3_column_text(sqlstatement, 4);
            NSString *descStr = [NSString stringWithUTF8String:descChar];
            [dict setValue:descStr forKey:@"Description"];
             NSLog(@"Description:%@",descStr);
            
            char* audioChar = (char*)sqlite3_column_text(sqlstatement, 6);
            NSString *audioStr = [NSString stringWithUTF8String:audioChar];
            [dict setValue:audioStr forKey:@"streetName"];
            NSLog(@"streetName:%@",audioStr);
            
            char* areaChar = (char*)sqlite3_column_text(sqlstatement, 10);
            NSString *areaStr = [NSString stringWithUTF8String:areaChar];
            [dict setValue:areaStr forKey:@"pincode"];
            NSLog(@"areaStr:%@",areaStr);
            
            char* fidChar = (char*)sqlite3_column_text(sqlstatement, 11);
            NSString *lat = [NSString stringWithUTF8String:fidChar];
            //[CGFloat ]lattitude = (CGFloat)[lat floatValue];
            [dict setValue:lat forKey:@"latitude"];
            NSLog(@"lat:%@",lat);
            
            char* fidlon = (char*)sqlite3_column_text(sqlstatement, 12);
            NSString *lon = [NSString stringWithUTF8String:fidlon];
            [dict setValue:lon forKey:@"longitude"];
            NSLog(@"lon:%@",lon);
            
            
            char* Photolon = (char*)sqlite3_column_text(sqlstatement, 15);
            NSString *photo = [NSString stringWithUTF8String:Photolon];
            [dict setValue:photo forKey:@"Photo"];
            NSLog(@"Photo:%@",photo);
            
            char* thumblon = (char*)sqlite3_column_text(sqlstatement, 16);
            NSString *thumb = [NSString stringWithUTF8String:thumblon];
            [dict setValue:thumb forKey:@"ThumbnailPhoto"];
            NSLog(@"thumb:%@",thumb);
            
            //
           
            // saving the record set in a MutableArray
            [recordSet addObject:dict];
            
            // clearing off the dictionary to make sure that it does not contain any garbage data
            dict = nil;
            
            // re- initalizing the dictionary for next record
            dict = [[NSMutableDictionary alloc]init];
        }
        
        // once all the fetching is one clearing off the dict variable for good.
        dict = nil;
        
    }
    
    
    return  recordSet;
    
}

-(NSString *)verifyStringValue:(NSString *)checkString
{
    
    NSString *strn = nil;
    
    if (((NSNull *)checkString == [NSNull null])||[checkString isEqualToString:@"<null>"]||[checkString isEqualToString:@"(null)"]||(checkString.length)<=0)
    {
        strn = @"";
    }
    else
    {
        strn  = checkString;
        
    }
    
    return strn;
}


-(BOOL)deleteHeritage:(NSString*)walkguid
{
    BOOL flag = NO ;
    
    NSString *sqliteQuery = [NSString stringWithFormat:@"Delete from heritage where heritagebuildinginfoguid = '%@'",walkguid];
    [self closeanyOpenConnection];
    
    sqlite3_stmt *sqlStatement = nil;
    if (sqlite3_prepare_v2(databaseReference, [sqliteQuery UTF8String], -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        sqlite3_step(sqlStatement);
        sqlite3_finalize(sqlStatement);
        sqlite3_close(databaseReference);
        flag = YES;
        NSLog(@"Table Row is deleted successfully..!!");
    }
    else
    {
        flag = NO;
    }
    
    return flag;
}
-(BOOL)deleteheritageplaces
{
     BOOL flag = NO ;
    NSString *sqliteQuery=[NSString stringWithFormat:@"Delete from heritage"];
    [self closeanyOpenConnection];
    sqlite3_stmt *sqlStatement=nil;
    if (sqlite3_prepare_v2(databaseReference, [sqliteQuery UTF8String], -1, &sqlStatement,NULL) == SQLITE_OK){
        sqlite3_step(sqlStatement);
        sqlite3_finalize(sqlStatement);
        sqlite3_close(databaseReference);
        flag=YES;
        NSLog(@"Table row is deleted successfully..!!");
    }
    else{
        flag=NO;
    }
    return flag;
}
- (BOOL)insert:(NSString *)guid andName:(NSString *)name andAlternative:(NSString*)alternative andCategory:(NSString*)category andDistance:(NSString *)distance andDescription:(NSString *)description andLattitude:(NSString *)lattitude andLongitide:(NSString *)longitude andPincode:(NSString *)pincode andPhoto:(NSString *)photo andThumbnailPhoto:(NSString *)thumbnailPhoto andLocation:(NSString *)location
{
        //    NSString *type = [[NSString alloc]init];
//        [self createNewTable];

        NSString *exp_date = [[NSString alloc]init];
        NSString *expquery = [[NSString alloc]init];
        NSLog(@"CWalk Name:%@",name);
        NSLog(@"CWalk GUID:%@",guid);
        if (guid.length!=0 && name.length!=0)
        {
            // checking for any previously open connection which was not closed
            [self closeanyOpenConnection];
           
            
            const char *expQuery = [expquery UTF8String];
            sqlite3_stmt *exptstatement = nil;
            
            if (sqlite3_prepare_v2(databaseReference, expQuery, -1, &exptstatement , NULL)==SQLITE_OK) {
                
                // declaring a dictionary so that response can be saved in KVC
                //            NSString *dict = [[NSString alloc]init];
                while (sqlite3_step(exptstatement) == SQLITE_ROW)
                {
                    char* guidChar = (char*)sqlite3_column_text(exptstatement, 0);
                    exp_date = [NSString stringWithUTF8String:guidChar];
                }
            }
            // preparing my sqlite query
            const char *sqliteQuery = "insert into heritage (`heritagebuildinginfoguid`,`Name`,`AlternativeNames`,`Category`,`Description`,`BuildingNo`,`StreetName`,`AliasStreetNames`,`Location`,`City`,`Pincode`,`Latitude`,`Longitude`,`Landmarks`,`SearchTags`,`Photo`,`ThumbnailPhoto`,`TextFile`,`AudioFile`,`VideoFile`) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            sqlite3_stmt *sqlstatement = nil;
            //        NSString *string = [[NSString alloc] initWithUTF8String:sqliteQuery];
            
            if (sqlite3_prepare_v2(databaseReference, sqliteQuery, -1, &sqlstatement, NULL)==SQLITE_OK )
            {
                sqlite3_bind_text(sqlstatement, 1, [guid UTF8String], -1,  SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlstatement, 2, [name UTF8String], -1,  SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlstatement, 3, [alternative UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlstatement, 4,  [category UTF8String], -1, SQLITE_TRANSIENT);
                // sqlite3_bind_blob64(sqlstatement, 4, [profileimage bytes], [profileimage length], SQLITE_STATIC);
                sqlite3_bind_text(sqlstatement, 5, [description UTF8String], -1,  SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlstatement, 7, [location UTF8String], -1,  SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlstatement, 11, [pincode UTF8String], -1,  SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlstatement, 12, [lattitude UTF8String], -1,  SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlstatement, 13, [longitude UTF8String], -1,  SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlstatement, 16, [photo UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(sqlstatement, 17, [thumbnailPhoto UTF8String], -1,  SQLITE_TRANSIENT);
               

                
//                NSString *urlString = [ROOT_URL stringByAppendingPathComponent:@"uploadedFiles"];
//                urlString = [urlString stringByAppendingPathComponent:guid];
//                urlString = [urlString stringByAppendingPathComponent:thumbnailPhoto];
//                NSURL *url = [NSURL URLWithString:urlString];
//                NSData *data = [NSData dataWithContentsOfURL:url];
//                sqlite3_bind_blob(sqlstatement, 3, [profileimage bytes], [profileimage length], NULL);
//                sqlite3_bind_text(sqlstatement, 4, [distance UTF8String], -1,  SQLITE_TRANSIENT);
                //                UIImageView *imageview = [[UIImageView alloc]init];
                //                [imageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
                // executes the sql statement with the data you need to insert in the db
                
                sqlite3_step(sqlstatement);
                // clearing the sql statement
                sqlite3_finalize(sqlstatement);
                //closing the database after the query execution
                sqlite3_close(databaseReference);

                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                NSLog(@"path is %@",documentsDirectory);
                return YES;
            }
            else
            {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                NSLog(@"path is %@",documentsDirectory);

                return NO;
            }
        }
        return NO;
}

-(BOOL)createNewTable
{
    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath=[array objectAtIndex:0];
    
    filePath =[filePath stringByAppendingPathComponent:@"yourdatabase.db"];
    
    NSFileManager *manager=[NSFileManager defaultManager];
    
    BOOL success = NO;
    if ([manager fileExistsAtPath:filePath])
    {
        success =YES;
    }
    if (!success)
    {
        NSString *path2=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"yourdatabase.db"];
        success =[manager copyItemAtPath:path2 toPath:filePath error:nil];
    }
    sqlite3_stmt *createStmt = nil;
    if (sqlite3_open([filePath UTF8String], &databaseReference) == SQLITE_OK) {
        if (createStmt == nil) {
            
            
            NSString *query=[NSString stringWithFormat:@"create table HERITAGE(heritagebuildinginfoguid text, name text ,ProfileImage blob, Distance text,Description text,Location text,Lattitude text,Longitude text,Pincode text,ThumbnailPhoto text)"];
            
            if (sqlite3_prepare_v2(databaseReference, [query UTF8String], -1, &createStmt, NULL) == SQLITE_OK) {
                sqlite3_exec(databaseReference, [query UTF8String], NULL, NULL, NULL);
                NSLog(@"Table is created");
                return YES;
                
            }
            return NO;
            
        }
    }
    return YES;
}
@end

