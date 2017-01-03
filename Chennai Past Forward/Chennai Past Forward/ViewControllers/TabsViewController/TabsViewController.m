
//  TabsViewController.m
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "TabsViewController.h"
#import "HomeViewController.h"
#import "MapViewController.h"
#import "TweetsViewController.h"
#import "HeritagePlacesViewController.h"
#import "ArticlesViewController.h"
#import "OffersViewController.h"
#import "NearByLocationViewController.h"
#import "NearByLocation.h"
#import "Request.h"
#import "Reachability.h"
#import "DatabaseHelper.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad


@interface TabsViewController ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *heritagesButton;
@property (strong, nonatomic) IBOutlet UIButton *articlesButton;
@property (strong, nonatomic) IBOutlet UIButton *offersButton;
@property (strong, nonatomic) IBOutlet UIButton *tweetsButton;
@property (strong, nonatomic) HeritagePlacesViewController *heritagePlacesViewController;
@property (strong, nonatomic) ArticlesViewController *articlesViewController;
@property (strong, nonatomic) OffersViewController *offersViewController;
@property (strong, nonatomic) TweetsViewController *tweetsController;
@property (strong, nonatomic) NearByLocationViewController *nearbylocation;
@property (strong, nonatomic) Request *request;
@end

@implementation TabsViewController
{
    CLLocationManager *locationManager;
}
- (id)init{
    
    if (IPAD)
    {
        self = [super initWithNibName:@"TabsViewController~iPad" bundle:nil];
    }
    else
    {
        self = [super initWithNibName:@"TabsViewController" bundle:nil];
    }
    
    if(self){
        
        
       
       //[self loadValuesofNearbyValue];
        
    }
    return self;
}


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self performSelector:@selector(heritageButtonTapped:) withObject:self.heritagesButton afterDelay:0.0];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _count=1;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
//    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(concurrentQueue, ^{
//        
//        
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            
//        });});
//    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
#pragma mark -

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark -

- (IBAction)heritageButtonTapped:(id)sender
{
    int n = 1000;
    [[NSUserDefaults standardUserDefaults]setInteger:n forKey:@"MapAnnotation"];
    [AlertView showProgress];
    NSLog(@"sqliteHeritage place size %lu",(unsigned long)[_sqliteHeritagePlaces count]);
    NSLog(@"Heritage place size %lu",(unsigned long)[_heritagePlaces count]);
    self.homeViewController.mapViewController.mkMapView.userInteractionEnabled=YES;
    if(_count!=0)
    {
    [self.homeViewController showTabsViewControllerAnimated:YES];
    }
    _count=_count+1;
    [self setHeritagePlacesViewController:[[HeritagePlacesViewController alloc] init]];
    [self.heritagePlacesViewController setRootViewController:self.rootViewController];
    [self.heritagePlacesViewController setTabsViewController:self];
    [self.heritagePlacesViewController setSqliteHeritagePlaces:_sqliteHeritagePlaces];
    [self.heritagePlacesViewController setHeritagePlaces:_heritagePlaces];
    [self.heritagePlacesViewController setAdditionalPhotos:self.AdditionalPhotos];
    [self.homeViewController.mapViewController setAddition:self.AdditionalPhotos];
    [self.heritagePlacesViewController.view setFrame:self.contentView.bounds];
    [self.contentView addSubview:self.heritagePlacesViewController.view];
    if(self.homeViewController.mapViewController.showDistance)
    {
    _showDistance=YES;
    }
    else{
    _showDistance=NO;
    }
    if (!self.homeViewController.isIndia)
    {
    _isIndiaTab=NO;
    [self.homeViewController.mapViewController zoomInToMyLocation];
    }
    else
    {
    _isIndiaTab = YES;
    }
    if([self connected] && [self.heritagePlaces count]!=0)
    {
    if(!_isIndiaTab)
    {
    [self.homeViewController.mapViewController addLocationMarkers:self.heritagePlaces];
    }
    }
    else
    {
    [self.homeViewController.mapViewController addLocationMarkers:self.sqliteHeritagePlaces];
    }
    if(!self.heritagesButton.selected)
    {
        self.heritagesButton.selected = YES;
        self.articlesButton.selected = NO;
        self.offersButton.selected = NO;
        self.tweetsButton.selected = NO;
        self.heritagesButton.backgroundColor = [UIColor whiteColor];
        self.articlesButton.backgroundColor  = [UIColor blackColor];
        self.offersButton.backgroundColor    = [UIColor blackColor];
        self.tweetsButton.backgroundColor    = [UIColor blackColor];
    }
    self.homeViewController.showbuttons;
    }

- (IBAction)articlesButtonTapped:(id)sender
{
    _showtab=NO;
    [self.homeViewController showTabsViewControllerAnimated:YES];
    [self setArticlesViewController:[[ArticlesViewController alloc] init]];
    [self.articlesViewController setArticles:self.articles];
    [self.articlesViewController setRootViewController:self.rootViewController];
    [self.articlesViewController setTabsViewController:self];
    [self.articlesViewController.view setFrame:self.contentView.bounds];
    [self.contentView addSubview:self.articlesViewController.view];
    self.homeViewController.mapViewController.titleLabel.hidden = YES;
    self.homeViewController.hidebuttons;
    if(!self.articlesButton.selected)
    {
        self.heritagesButton.selected = NO;
        self.articlesButton.selected = YES;
        self.offersButton.selected = NO;
        self.tweetsButton.selected = NO;
        self.heritagesButton.backgroundColor    = [UIColor blackColor];
        self.articlesButton. backgroundColor    = [UIColor whiteColor];
        self.offersButton.   backgroundColor    = [UIColor blackColor];
        self.tweetsButton.   backgroundColor    = [UIColor blackColor];
    }
}

- (IBAction)offersButtonTapped:(id)sender
{
     _showtab=NO;
    self.homeViewController.isIndia=NO;
    [AlertView showProgress];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MapAnnotation"];
    [self.homeViewController showTabsViewControllerAnimated:YES];
    [self setNearbylocation:[[NearByLocationViewController alloc] init]];
    [self.nearbylocation setNearbyArr:_nearPlace];
    [self.nearbylocation setItems:_commontypes];
    NSLog(@"count in tab %lu",(unsigned long)_btnselectArr.count);
    [self.nearbylocation setBtnselectArr:_btnselectArr];
    [self.nearbylocation setDummyArr1:_dummyArr1];
    [self.nearbylocation setRootViewController:self.rootViewController];
    [self.nearbylocation setTabsViewController:self];
    [self.nearbylocation.view setFrame:self.contentView.bounds];
    [self.contentView addSubview:self.nearbylocation.view];
    [self.homeViewController.mapViewController zoomInToMyLocation];
    self.homeViewController.mapViewController.titleLabel.hidden = YES;
    [self.homeViewController.mapViewController addLocationMarkersForPlaces:_nearPlace];
    self.homeViewController.hidebuttons;
    if(!self.offersButton.selected)
    {
        self.heritagesButton.selected = NO;
        self.articlesButton.selected  = NO;
        self.offersButton.selected    = YES;
        self.tweetsButton.selected    = NO;
        self.heritagesButton.backgroundColor = [UIColor blackColor];
        self.articlesButton.backgroundColor  = [UIColor blackColor];
        self.offersButton.backgroundColor    = [UIColor whiteColor];
        self.tweetsButton.backgroundColor    = [UIColor blackColor];
    }
    [AlertView hideAlert];


}

- (IBAction)tweetsButtonTapped:(id)sender
{
     _showtab=NO;
    [self.homeViewController showTabsViewControllerAnimated:YES];
    self.tweetsController = [[TweetsViewController alloc] init];
    [self.tweetsController setRootViewController:self.rootViewController];
    [self.tweetsController setTabsViewController:self];
    [self.tweetsController.view setFrame:self.contentView.bounds];
    [self.contentView addSubview:self.tweetsController.view];
    self.homeViewController.mapViewController.titleLabel.hidden = YES;
    self.homeViewController.hidebuttons;
    if(!self.tweetsButton.selected)
    {
        self.heritagesButton.selected = NO;
        self.articlesButton.selected = NO;
        self.offersButton.selected = NO;
        self.tweetsButton.selected = YES;
        self.heritagesButton.backgroundColor = [UIColor blackColor];
        self.articlesButton.backgroundColor = [UIColor blackColor];
        self.offersButton.backgroundColor = [UIColor blackColor];
        self.tweetsButton.backgroundColor = [UIColor whiteColor];
    }
}


#pragma mark -

- (void)loadTabsViewContent
{
    [self clearContentView];
    
    if([self.homeViewController.searchBy isEqualToString:@"Heritage"])
    {
        [self heritageButtonTapped:self.heritagesButton];
    }
    else if([self.homeViewController.searchBy isEqualToString:@"Articles"])
    {
        [self articlesButtonTapped:self.heritagesButton];
    }
    else if([self.homeViewController.searchBy isEqualToString:@"CurrentLocation"])
    {
        [self.homeViewController hideTabsViewControllerAnimated:YES];
        [self.homeViewController.mapViewController zoomInToMyLocation];
        
        if([self connected]&&[self.heritagePlaces count]!=0)
        {
            [self.homeViewController.mapViewController addLocationMarkers:self.heritagePlaces];
        }
        else{
            [self.homeViewController.mapViewController addLocationMarkers:self.sqliteHeritagePlaces];
        }
    }
    else if([self.homeViewController.searchBy isEqualToString:@"IndiaMap"])
    {
        [self.homeViewController hideTabsViewControllerAnimated:YES];
        //[self.homeViewController.mapViewController zoomInToMyLocation];
        
        if([self connected]&&[self.heritagePlaces count]!=0)
        {
            //[self.homeViewController.mapViewController addLocationMarkers:self.heritagePlaces];
        }
        else{
            [self.homeViewController.mapViewController addLocationMarkers:self.sqliteHeritagePlaces];
        }
    }

//    if([self.homeViewController.searchBy isEqualToString:@"Near By"])
//    {
//        [self heritageButtonTapped:self.offersButton];
//    }
}
-(void)opendetailspage{
    //[self.homeViewController.mapViewController callDetailsView:sender];
}
-(void)reloadHeritage_Places{

}

- (void)clearContentView{
    for (UIView *aview in self.contentView.subviews) {
        [aview removeFromSuperview];
    }
}
- (void)reloadHeritagePlaces
{
    [self.heritagePlacesViewController.tableView reloadData];
}
- (void)reloadNearByPlaces
{
     [self.nearbylocation.nearTableView reloadData];
}
#pragma mark -


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    if(self.location == nil)
    {
        self.location = [locations lastObject];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
       
        [parameters setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.latitude] forKey:@"lat"];
        [parameters setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.longitude] forKey:@"lng"];
        [Request makeRequestWithIdentifier:NEARBY_SEARCH parameters:parameters delegate:self.homeViewController];
    }
}

- (void)connection:(Connection *)connection didReceiveData:(id)data
{
   
    if([data isKindOfClass:[NSString class]])
    {
        data = [data jsonValue];
    }
    _nearPlace = [NSMutableArray arrayWithArray:[self parseOffers:data]];
    _commontypes=[NSMutableArray arrayWithArray:[self parseCommonTypes:data]];
    NSLog(@"common types %@",data);
    [AlertView hideAlert];
    
}

- (void)connection:(Connection *)connection didFailWithError:(NSError *)error{
    [AlertView hideAlert];
}

- (NSArray *)parseOffers:(NSDictionary *)data
{
    ////3
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if([data containsKey:@"NearByBuildings"])
    {
        data = [data objectForKey:@"NearByBuildings"];
        for (NSDictionary *offerDictionary in data) {
            [array addObject:[NearByLocation objectFromDictionary:offerDictionary]];
        }
    }
    
    return array;
}
-(NSArray *)parseCommonTypes:(NSDictionary *)data
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if([data containsKey:@"CommonTypes"])
    {
        data = [data objectForKey:@"CommonTypes"];
        for (NSDictionary *offerDictionary in data) {
            [array addObject:[CommonTypes objectFromDictionary:offerDictionary]];
        }
    }
    
    return array;

}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
//-(void)loadValuesofNearby
//{
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    
//    float lat = [[NSUserDefaults standardUserDefaults]floatForKey:@"Lattitude"];
//    float lon = [[NSUserDefaults standardUserDefaults]floatForKey:@"Longitude"];
//    
//    NSLog(@"%f ,%f",lat,lon);
//    
//    [parameters setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"lat"];
//    [parameters setObject:[NSString stringWithFormat:@"%f",lon] forKey:@"lng"];
//    [Request makeRequestWithIdentifier:NEARBY_SEARCH parameters:parameters delegate:self];
//    
//   
//}

//-(BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
//{
//    return UIInterfaceOrientationIsPortrait(orientation);
//}
@end
