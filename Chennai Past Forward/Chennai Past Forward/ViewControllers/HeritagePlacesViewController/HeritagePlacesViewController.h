//
//  HeritagePlacesViewController.h
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController, TabsViewController,MapViewController,HomeViewController;
@interface HeritagePlacesViewController : UITableViewController<CLLocationManagerDelegate>
{
    BOOL isOK ;
     CLLocationManager *locationManager;
    NSData *imgData;
}
@property (strong, nonatomic) MapViewController *mapViewController;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) TabsViewController *tabsViewController;
@property (strong,nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) NSMutableArray *heritagePlaces;
@property (strong,nonatomic) NSMutableArray *heritageIndiaPlaces;
@property (strong, nonatomic) NSMutableArray *AdditionalPhotos;
@property (strong) NSManagedObject *managedObj;
@property (strong, nonatomic) NSMutableArray *sqliteHeritagePlaces;


@property (strong) NSMutableArray *devices;
@property (strong) NSManagedObject *managed;
@property (strong) NSMutableArray *heritage;
@property (strong, nonatomic) id detailObject;
-(void)reload_data;

@end
