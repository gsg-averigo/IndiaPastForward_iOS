//
//  TabsViewController.h
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController, HomeViewController;
@interface TabsViewController : UIViewController<ConnectionDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) NSMutableArray *sqliteHeritagePlaces;

@property (strong, nonatomic) NSMutableArray *heritagePlaces;
@property (strong, nonatomic) NSMutableArray *heritageIndiaPlaces;
@property (strong, nonatomic) NSMutableArray *articles;
@property (strong, nonatomic) NSMutableArray *offers;
@property (strong, nonatomic) NSMutableArray *nearPlace;
@property (strong, nonatomic) NSMutableArray *commontypes;
@property (strong, nonatomic) NSMutableArray *btnselectArr;
@property (strong, nonatomic) NSMutableArray *dummyArr1;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic,assign)BOOL isIndiaTab;
@property (nonatomic,assign)BOOL showDistance;
@property (nonatomic,assign)BOOL showtab;
@property (nonatomic,assign)int count;

@property (strong,nonatomic) NSMutableArray *AdditionalPhotos;
- (void)loadTabsViewContent;
- (void)reloadHeritagePlaces;
- (void)reloadNearByPlaces;
- (void)reloadHeritage_Places;
//- (void)opendetailspage:(UITapGestureRecognizer *)sender;
-(void)opendetailspage;

@end
