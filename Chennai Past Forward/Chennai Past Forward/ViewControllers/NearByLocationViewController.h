//
//  NearByLocationViewController.h
//  Chennai Past Forward
//
//  Created by BTS on 02/02/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabsViewController.h"
#import "RootViewController.h"
#import "HomeViewController.h"
#import "NearByLocation.h"
#import "CommonTypes.h"
#import "NSObject+Parser.h"
#import "MapViewController.h"
#import "FilterActionSheetViewController.h"

@class RootViewController, TabsViewController,MapViewController,HomeViewController;

@interface NearByLocationViewController : UIViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) TabsViewController *tabsViewController;
@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) MapViewController *mapViewController;
@property (strong, nonatomic) FilterActionSheetViewController *filteractionsheet;
@property (strong, nonatomic) NSMutableArray *offers;
@property (strong, nonatomic) NSMutableArray *nearbyArr;
@property (strong, nonatomic) NSMutableArray *dummyArr;
@property (strong, nonatomic) NSMutableArray *dummyArr1;
@property (strong, nonatomic) NSMutableArray *btnselectArr;
@property (strong, nonatomic) NSMutableArray *filterselectArr;
@property (strong, nonatomic) NSMutableArray *deleteArr;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) IBOutlet UITableView *nearTableView;
@property (strong, nonatomic) IBOutlet UIButton *filter_btn;
@property (strong, nonatomic) UITableView *optionview;
@property (strong, nonatomic) UILabel *nearbyplaces_lbl;
@property (strong, nonatomic) UILabel *nonearby_lbl;
@property (strong, nonatomic) UIButton *searchnearby_btn;
@property (strong, nonatomic) UIView *popup_view;


-(IBAction)filterbtn_click:(id)sender;

@end

NSInteger rowNo;
NearByLocation *nearlocation;
CommonTypes *commontypes;