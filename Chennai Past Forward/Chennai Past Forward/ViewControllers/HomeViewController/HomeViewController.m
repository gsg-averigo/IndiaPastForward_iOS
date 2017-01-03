//
//  HomeViewController.m
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#import "HomeViewController.h"
#import "RootViewController.h"
#import "DetailViewController.h"
#import "MapViewController.h"
#import "TabsViewController.h"
#import "OffersViewController.h"
#import "Request.h"
#import "AlertView.h"
#import "Categories.h"
#import "NSObject+Parser.h"
#import "Photo.h"
#import "HeritagePlace.h"
#import "Article.h"
#import "Offer.h"
#import "Message.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "UIDevice+IdentifierAddition.h"
#import <CoreData/CoreData.h>
#import "NearByLocationViewController.h"
#import "NearByLocation.h"
#import "CommonTypes.h"
#import "DatabaseHelper.h"
#import <CraftARCloudImageRecognitionSDK/CraftARSDK.h>
#import <CraftARCloudImageRecognitionSDK/CraftARCloudRecognition.h>
#import "DetailViewController.h"
#import "EnquiryPhotoViewController.h"
#import "CustomCameraViewController.h"

@interface HomeViewController ()
{
    NSDictionary *dict;
     CraftARSDK *_sdk;
}
@end

@implementation HomeViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


#pragma mark -

- (id)init{
    
    // self = [super initWithNibName:@"HomeViewController" bundle:nil];
    if (IPAD) {
        self = [super initWithNibName:@"HomeViewController~iPad" bundle:nil];
    }
    else {
        self = [super initWithNibName:@"HomeViewController" bundle:nil];
    }
    
    if(self){
        self.searchBy = @"Heritage";
    }
    return self;
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

#pragma mark -

- (void)viewDidLoad{
    [super viewDidLoad];

    dict = [[NSDictionary alloc] init];
  //devices = [[NSMutableArray alloc] init];
//self.mapViewController.enquiry_btn=[[UIButton alloc]init];
//[self.mapViewController onEnquiryBtnClick:self.mapViewController.enquiry_btn];
    self.Enquiry_btn = [[UIButton alloc]init];
    self.India_location_btn=[[UIButton alloc]init];
    self.Cur_location_btn=[[UIButton alloc]init];
    if (IPAD)
    {
        self.mapViewController.mkMapView.height = 340;
        self.tabsViewController.view.top = 340;
        NSLog(@"tab width %f",self.mapViewController.mkMapView.width);
        float Y_Co = (self.mapViewController.mkMapView.height - 150);
        float X_Co = 700;
        if([self connected])
        {
            [self.Enquiry_btn setFrame:CGRectMake(X_Co,290, 40, 32)];//Y_Co
            [self.India_location_btn setFrame:CGRectMake(X_Co,250, 40, 32)];//Y_Co-50
            [self.Cur_location_btn setFrame:CGRectMake(X_Co,200 , 40, 32)]; //Y_Co-90
            self.coachMarks = @[
                                @{
                                    @"rect": [NSValue valueWithCGRect:(CGRect){{695,190},{50,50}}],
                                    @"caption": @"Use this to refresh places of heritage nearby",
                                    @"shape": @"circle"
                                    },
                                @{
                                    @"rect": [NSValue valueWithCGRect:(CGRect){{695,235},{50,50}}],
                                    @"caption": @"Use this to view places of heritage throughout India",
                                    @"shape": @"circle"

                                    },
                                @{
                                    @"rect": [NSValue valueWithCGRect:(CGRect){{695,280},{50,50}}],
                                    @"caption": @"Ask us your heritage question",
                                    @"shape": @"circle"
                                    },
                                @{
                                    @"rect": [NSValue valueWithCGRect:(CGRect){{self.view.width-(self.view.width/2),340},{self.view.width/4,40}}],
                                    @"caption": @"shows info from Google. This info is from Google and we don’t moderate this",
                                    @"shape": @"square"

                                    },
                                @{
                                    @"rect": [NSValue valueWithCGRect:(CGRect){{self.view.width-(self.view.width/4),340},{self.view.width/4,40}}],
                                    @"caption": @"Get your tweets to show here when you tweet using #PastForward",
                                    @"shape": @"square"
 
                                    }
                                ];
            coachMarksView = [[WSCoachMarksView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height-100) coachMarks:self.coachMarks];

        }
        
    }
    else
    {
        self.mapViewController.mkMapView.height = 148;
        self.tabsViewController.view.top = 148;
        float Y_Co = (self.mapViewController.mkMapView.height - 50);
        float X_Co = self.mapViewController.mkMapView.width-50;
        if([self connected])
        {
            [self.Enquiry_btn setFrame:CGRectMake(X_Co,90, 40, 32)];
            [self.India_location_btn setFrame:CGRectMake(X_Co,50,40, 32)];
            [self.Cur_location_btn setFrame:CGRectMake(X_Co,10, 40, 32)];
            self.coachMarks = @[
                                @{
                                    @"rect": [NSValue valueWithCGRect:(CGRect){{self.view.width-55,10},{50,45}}],
                                    @"caption": @"Use this to refresh places of heritage nearby",
                                    @"shape": @"circle"
                                    },
                                @{
                                    @"rect": [NSValue valueWithCGRect:(CGRect){{self.view.width-55,50},{50,45}}],
                                    @"caption": @"Use this to view places of heritage throughout India",
                                    @"shape": @"circle"
                                    },
                                @{
                                    @"rect": [NSValue valueWithCGRect:(CGRect){{self.view.width-55,90},{50,45}}],
                                    @"caption": @"Ask us your heritage question",
                                    @"shape": @"circle"
                                    },
                                @{
                                    @"rect": [NSValue valueWithCGRect:(CGRect){{self.view.width-(self.view.width/2),148},{self.view.width/4,40}}],
                                    @"caption": @"shows info from Google. This info is from Google and we don’t moderate this",
                                    @"shape": @"square"
                                    },
                                @{
                                    @"rect": [NSValue valueWithCGRect:(CGRect){{self.view.width-(self.view.width/4),148},{self.view.width/4,40}}],
                                    @"caption": @"Get your tweets to show here when you tweet using #PastForward",
                                    @"shape": @"square"
                                    }
                            ];
            coachMarksView = [[WSCoachMarksView alloc] initWithFrame:CGRectMake(0,0,self.view.width,self.view.height+30) coachMarks:self.coachMarks];
            
           
}
    }
    

    [self.Enquiry_btn setImage:[UIImage imageNamed:@"query2.png"] forState:UIControlStateNormal];
    [self.Enquiry_btn addTarget:self action:@selector(onEnquiryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.India_location_btn setImage:[UIImage imageNamed:@"india(normal).png"] forState:UIControlStateNormal];
       [self.India_location_btn addTarget:self action:@selector(indiaMap:) forControlEvents:UIControlEventTouchUpInside];
    [self.Cur_location_btn setImage:[UIImage imageNamed:@"current_icon2.png"] forState:UIControlStateNormal];//
       [self.Cur_location_btn addTarget:self action:@selector(currentLocation:) forControlEvents:UIControlEventTouchUpInside];
    self.tooltip=[[UILabel alloc]init];
    [self.tooltip setFrame:CGRectMake(self.view.frame.size.width-200,70, 150, 20)];
    self.tooltip.text = @"send enquiry to admin";
    self.tooltip.numberOfLines = 1;
   
    //fromLabel.adjustsFontSizeToFitWidth = YES;
    //fromLabel.adjustsLetterSpacingToFitWidth = YES;
    //fromLabel.minimumScaleFactor = 10.0f/12.0f;
    self.tooltip.clipsToBounds = YES;
    self.tooltip.backgroundColor = [UIColor blackColor];
    self.tooltip.textColor = [UIColor whiteColor];
    self.tooltip.textAlignment = NSTextAlignmentLeft;
    self.tooltip.layer.cornerRadius=6;
    //[collapsedViewContainer addSubview:fromLabel];
    //[self.mapViewController addSubview:self.Enquiry_btn];
    if(IPAD)
    {
        self.mapViewController = [[MapViewController alloc] init];
        [self.mapViewController viewWillAppear:YES];
        [self.mapViewController setRootViewController:self.rootViewController];
        [self.mapViewController setHomeViewController:self];
        [self.mapViewController.view setSize:CGSizeMake(768, 340)];
        [self.view addSubview:self.mapViewController.view];
        [self.mapViewController.mkMapView setUserInteractionEnabled:YES];
        if([self connected])
        {
        [self.view addSubview:self.Enquiry_btn];
        [self.view addSubview:self.India_location_btn];
        [self.view addSubview:self.Cur_location_btn];
        }
    }
    else
    {
        self.mapViewController = [[MapViewController alloc] init];
        [self.mapViewController viewWillAppear:YES];
        [self.mapViewController setRootViewController:self.rootViewController];
        [self.mapViewController setHomeViewController:self];
        [self.mapViewController.view setSize:CGSizeMake(320, 148)];
        [self.view addSubview:self.mapViewController.view];
        [self.mapViewController.mkMapView setUserInteractionEnabled:YES];
        if([self connected])
        {
            [self.view addSubview:self.Enquiry_btn];
            [self.view addSubview:self.India_location_btn];
             [self.view addSubview:self.Cur_location_btn];
        }
    }
    self.tabsViewController = [[TabsViewController alloc] init];
    [self.tabsViewController setRootViewController:self.rootViewController];
    [self.tabsViewController setHomeViewController:self];
    [self.tabsViewController.view setTop:self.mapViewController.view.bottom];
   // if(IPAD)
   // {
    [self.tabsViewController.view setSize:CGSizeMake(320, self.view.height - self.tabsViewController.view.top)];
   // }
//    else{
//        [self.tabsViewController.view setSize:CGSizeMake(380, self.view.height - self.tabsViewController.view.top)];
//    }
    [self.view addSubview:self.tabsViewController.view];
    if (![self connected])
    {
    [AlertView showAlertMessage:@"Please Check Your Internet Connection"];
    [self loadDefaultResponse];
    }
     [self.view addSubview:coachMarksView];
       double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"WSCoachMarksShown"];
        if (coachMarksShown == NO) {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WSCoachMarksShown"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [coachMarksView start];
            
        }
    });
    
    
}
- (void)backgroundTapped:(UITapGestureRecognizer *)gesture
{
    NSLog(@"BACKGROUND TAPPED");
//    [self.mapViewController.mkMapView setUserInteractionEnabled:YES];
//    [self.view removeGestureRecognizer:gesture];
//    [self hideTabsViewControllerAnimated:YES];
}
-(void)hidebuttons
{
    self.Cur_location_btn.hidden = YES;
    self.India_location_btn.hidden = YES;
}
-(void)showbuttons
{
    self.Cur_location_btn.hidden = NO;
    self.India_location_btn.hidden = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void) viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
   // [_sdk stopCapture];
}

#pragma mark -

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
-(IBAction)onEnquiryBtnClick:(id)sender
{
    NSLog(@"enquiry btn clicked");
    //EnquiryPhotoViewController *detailViewController = [[EnquiryPhotoViewController alloc]
    //  initWithNibName:@"EnquiryPhotoViewController" bundle:nil];
    NSLog(@"view size:%f",self.view.size);
    
    CustomCameraViewController *detailViewController = [[CustomCameraViewController alloc]initWithNibName:@"CustomCameraViewController" bundle:nil];
    [detailViewController setRootViewController:self.rootViewController];
    
    if(IPAD)
    {
        [detailViewController.view setSize:CGSizeMake(768, 1024)];
        //[detailViewController.view setSize:self.view.size];
    }
//    else
//    {
//        [detailViewController.view setSize:CGSizeMake(320, 148)];
//    }
    
    
    NSLog(@"frame width %f",self.view.width);
    NSLog(@"frame height %f",self.view.height);
    [self.rootViewController pushViewController:detailViewController animated:YES];
}- (IBAction)indiaMap:(id)sender
{
    _isIndia=YES;
    [self.India_location_btn setImage:[UIImage imageNamed:@"india_icon2.png"] forState:UIControlStateNormal];
    [self.Cur_location_btn setImage:[UIImage imageNamed:@"user(normal).png"] forState:UIControlStateNormal];

    self.mapViewController.showIndiaMap;
}
- (IBAction)currentLocation:(id)sender
{
    _isIndia=NO;
    [self.India_location_btn setImage:[UIImage imageNamed:@"india(normal).png"] forState:UIControlStateNormal];
    [self.Cur_location_btn setImage:[UIImage imageNamed:@"current_icon2.png"] forState:UIControlStateNormal];

    self.mapViewController.showCurrentLocation;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self connected])
    {
    [self.rootViewController popToRootViewControllerAnimated:YES];
    [textField resignFirstResponder];
    
    if([self.searchBy isEqualToString:@"Heritage"])
    {
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
        [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
        [parameters setObject:textField.text forKey:@"strSearchString"];
        [parameters setObject: [NSString stringWithFormat:@"%f",self.mapViewController.location.coordinate.latitude] forKey:@"strLatitude"];
        [parameters setObject: [NSString stringWithFormat:@"%f",self.mapViewController.location.coordinate.longitude] forKey:@"strLongitude"];
        [parameters setObject:@"ENG" forKey:@"strLanguageCode"];
        [Request makeRequestWithIdentifier:SEARCH_HERITAGE parameters:parameters delegate:self];
        [AlertView showProgress];
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"tag"];
    }
    else if([self.searchBy isEqualToString:@"Articles"])
    {
        if ([self connected]) {
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
            [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
            [parameters setObject:textField.text forKey:@"strSearchString"];
            [Request makeRequestWithIdentifier:SEARCH_ARTICLE parameters:parameters delegate:self];
            [AlertView showProgress];
        }
        else
        {
            NSLog(@"NO Internet Acess");
        }
        
        
    }
    }
    else{
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"IndiaPastForward"
                                                              message:@"Not available in offline mode!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Show"])
        {
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
            [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
            [parameters setObject:[NSString stringWithFormat:@"%f",self.mapViewController.location.coordinate.latitude] forKey:@"strLatitude"];
            [parameters setObject:[NSString stringWithFormat:@"%f",self.mapViewController.location.coordinate.longitude] forKey:@"strLongitude"];
            [Request makeRequestWithIdentifier:SEARCH_LATLONG parameters:parameters delegate:self];
            [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"tag"];
        }
    }
}
- (void)alertViewCancel:(UIAlertView *)alertView
{
    
}

#pragma mark -

- (void)connection:(Connection *)connection didReceiveData:(id)data
{
    [AlertView hideAlert];
    if([data isKindOfClass:[NSString class]])
    {
        data = [data jsonValue];
    }
    
    if(connection.connectionIdentifier == SEARCH_HERITAGE || connection.connectionIdentifier == SEARCH_ARTICLE || connection.connectionIdentifier == SEARCH_LATLONG)
    {
        
        if([[data objectForKey:@"success"] boolValue])
        {
//            NSLog(@"Array ====>>>>%@",self.tabsViewController.heritagePlaces);
//            [self.tabsViewController.heritagePlaces removeAllObjects];
            
            self.tabsViewController.heritagePlaces = [NSMutableArray arrayWithArray:[self parseHeritagePlaces:data]];
            self.tabsViewController.articles = [NSMutableArray arrayWithArray:[self parseArticles:data]];
            self.tabsViewController.AdditionalPhotos = [NSMutableArray arrayWithArray:[self parseAdditionalPhotos:data]];
            if(connection.connectionIdentifier==SEARCH_LATLONG)
            {
                if(self.tabsViewController.heritagePlaces.count!=0)
                {
                   [self.tabsViewController loadTabsViewContent];
                }
                else{
                    [self loadDefaultResponse];
                }
                
            }
            else
            {
            [self.tabsViewController loadTabsViewContent];
            }
           // [self.tabsViewController reloadHeritage_Places];
        }
        else{
            [self.tabsViewController loadTabsViewContent];
        }
        
    }
    else if(connection.connectionIdentifier == MESSAGEBOX_INFO)
    {
        [AlertView hideAlert];
        if([[data objectForKey:@"success"] boolValue]){
            [AlertView hideAlert];
            NSMutableArray *items = [NSMutableArray arrayWithArray:[self parseNotificationAndOffers:[data objectForKey:@"NotificationAndOffers"]]];
            
            
            OffersViewController *offersViewController = [[OffersViewController alloc] init];
            offersViewController.rootViewController = self.rootViewController;
            offersViewController.tabsViewController = self.tabsViewController;
            offersViewController.offers = items;
            offersViewController.heritagePlaces=self.tabsViewController.heritagePlaces;
            offersViewController.addition = [NSMutableArray arrayWithArray:[self parseAdditionalPhotos:data]];
            [self.rootViewController pushViewController:offersViewController animated:YES];
        }
        
        else
        {
            [AlertView hideAlert];
        }
        
        
    }
    
    else if(connection.connectionIdentifier == COUNT_BY_LOCATION)
    {
        if([[data objectForKey:@"success"] boolValue])
        {
            UIAlertView *alertView = [[UIAlertView alloc] init];
            alertView.tag = 1;
            alertView.delegate = self;
            alertView.title = @"Past Forward";
            alertView.message = [NSString stringWithFormat:@"%@ Heritage Buildings found near your Current Location! Tap to View!",data[@"Count"]];
            [alertView addButtonWithTitle:@"Show"];
            [alertView addButtonWithTitle:@"Cancel"];
            [alertView setCancelButtonIndex:1];
            [alertView show];
        }
    }
    else if(connection.connectionIdentifier == NEARBY_SEARCH)
    {
        NSLog(@"nearby json data %@",data);
        _btnselectArr=[[NSMutableArray alloc]init];
        _dummyArr1=[[NSMutableArray alloc]init];
        self.tabsViewController.nearPlace = [NSMutableArray arrayWithArray:[self parseOffers1:data]];
        self.tabsViewController.dummyArr1=self.tabsViewController.nearPlace;
        self.tabsViewController.commontypes=[NSMutableArray arrayWithArray:[self parseCommonTypes:data]];
        for (int i=0; i<self.tabsViewController.commontypes.count; i++) {
            [_btnselectArr addObject:@NO];
        }
        NSLog(@"btnselectarr size %lu",(unsigned long)_btnselectArr.count);
        self.tabsViewController.btnselectArr=_btnselectArr;

       
    }
    else
    {
        [AlertView hideAlert];
    }
        
    self.mapViewController.addition =  [NSMutableArray arrayWithArray:[self parseAdditionalPhotos:data]];
}


- (void)connection:(Connection *)connection didFailWithError:(NSError *)error{
    [AlertView hideAlert];
}


#pragma mark -

- (void)showTabsViewControllerAnimated:(BOOL)animated{
    [UIView animateWithDuration:(animated) ? 0.25 : 0.0
                     animations:^ (void)
     {
         NSLog(@"SHOWTAB");
       
         [self.mapViewController.mkMapView setUserInteractionEnabled:YES];
         if (IPAD) {
             self.mapViewController.mkMapView.height = 340;
             self.tabsViewController.view.top = 340;
             NSLog(@"tab width %f",self.mapViewController.mkMapView.width);
             float Y_Co = (self.mapViewController.mkMapView.height - 50);
             float X_Co = 700;
             if([self connected])
             {
                 [self.Enquiry_btn setFrame:CGRectMake(X_Co, Y_Co, 40, 32)];
                  [self.Cur_location_btn setFrame:CGRectMake(X_Co, Y_Co-90, 40, 32)];
                 [self.India_location_btn setFrame:CGRectMake(X_Co, Y_Co-50, 40, 32)];
             }

         }
         else
         {
             self.mapViewController.mkMapView.height = 148;
             self.tabsViewController.view.top = 148;
             float Y_Co = (self.mapViewController.mkMapView.height - 50);
             float X_Co = self.mapViewController.mkMapView.width-50;
             if([self connected])
             {
                 [self.India_location_btn setFrame:CGRectMake(X_Co, Y_Co-40, 40, 32)];
                 [self.Cur_location_btn setFrame:CGRectMake(X_Co, Y_Co-80, 40, 32)];
                 [self.Enquiry_btn setFrame:CGRectMake(X_Co, Y_Co, 40, 32)];
            }
         }
     }
                     completion:^ (BOOL finished){
                         UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.mapViewController action:@selector(backgroundTapped:)];
                         [self.mapViewController.view addGestureRecognizer:tapGesture];
                         

                        
                     }];
    
}

- (void)hideTabsViewControllerAnimated:(BOOL)animated{
    [UIView animateWithDuration:(animated) ? 0.25 : 0.0
                     animations:^ (void){
                         NSLog(@"showmap");
                         if (IPAD) {
                             self.mapViewController.view.height = 886;
                             self.mapViewController.mkMapView.height = 886;
                             self.tabsViewController.view.top = 886;
                             float Y_Co = (self.mapViewController.mkMapView.height - 50);
                             float X_Co = 700;
                             if([self connected])
                             {
                                 [self.Enquiry_btn setFrame:CGRectMake(X_Co, Y_Co, 40, 32)];
                                 //[self.tooltip setFrame:CGRectMake(X_Co-10, Y_Co-20, 60, 20)];
                                   [self.Cur_location_btn setFrame:CGRectMake(X_Co, Y_Co-90, 40, 32)];
                                 [self.India_location_btn setFrame:CGRectMake(X_Co, Y_Co-50, 40, 32)];
                             }

                         }
                         else
                         {
                             self.mapViewController.view.height = self.view.height - 44;
                             self.mapViewController.mkMapView.height = self.view.height - 44;
                             self.tabsViewController.view.top = self.view.height - 44;
                             float Y_Co = (self.mapViewController.mkMapView.height - 50);
                             float X_Co =  self.mapViewController.mkMapView.width-50;
                             if([self connected])
                             {
                                 [self.India_location_btn setFrame:CGRectMake(X_Co, Y_Co-40, 40, 32)];
                                 [self.Cur_location_btn   setFrame:CGRectMake(X_Co, Y_Co-80, 40, 32)];
                                 [self.Enquiry_btn        setFrame:CGRectMake(X_Co, Y_Co,40,32)];
                             }
                         }
                         
                     }
                     completion:^ (BOOL finished)
     
     {
         //self.tabsViewController.view.height = self.contentView.height - self.tabsViewController.view.top;
     }];
}


#pragma mark -

- (void)loadDefaultResponse
{
//    if ([self connected])
//    {
//        NSString *file = [[NSBundle mainBundle] pathForResource:@"DefaultResponse" ofType:@"json"];
//        NSDictionary *data = [[[NSFileManager defaultManager] contentsAtPath:file] jsonValue];
//        self.tabsViewController.heritagePlaces = [NSMutableArray arrayWithArray:[self parseHeritagePlaces:data]];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sucess"];
//        self.tabsViewController.articles = [NSMutableArray arrayWithArray:[self parseArticles:data]];
//        self.tabsViewController.offers = [NSMutableArray arrayWithArray:[self parseOffers:data]];
//        [self.tabsViewController loadTabsViewContent];
//    }
    
    DatabaseHelper *databasehelper = [[DatabaseHelper alloc] init];
    [databasehelper createDatabaseInstance];
    
    self.tabsViewController.sqliteHeritagePlaces = [databasehelper getAllRecords];
    [self.tabsViewController loadTabsViewContent];
    
    
    
//    if (![self connected])
//    {
////        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
////        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] initWithEntityName:@"HeritageBuildingInfoList"];
////        Heritage_devices =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
////        self.tabsViewController.heritagePlaces = Heritage_devices;
////        //    self.tabsViewController.articles = Heritage_devices;
////        //    self.tabsViewController.offers = Heritage_devices;
////        //    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"sucess"];
////        [self.tabsViewController loadTabsViewContent];
//    }else
//    {
////        NSMutableArray *arra = [[NSMutableArray alloc]init];
//        DatabaseHelper *databasehelper = [[DatabaseHelper alloc] init];
//        [databasehelper createDatabaseInstance];
//        self.tabsViewController.sqliteHeritagePlaces = [databasehelper getAllRecords];
//        [self.tabsViewController loadTabsViewContent];
//    }
}

- (NSArray *)parseHeritagePlaces:(NSDictionary *)data
{
    ///1
    
     NSMutableArray *array = [[NSMutableArray alloc] init];

        if([data containsKey:@"HeritageBuildingInfo"])
        {
            data = [data objectForKey:@"HeritageBuildingInfo"];
            for (NSDictionary *heritagePlaceDictionary in data)
            {
                [array addObject:[HeritagePlace objectFromDictionary:heritagePlaceDictionary]];
            }
        }

    return array;
}

-(NSArray *)parseArticles:(NSDictionary *)data
{
    
    ///2
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if([data containsKey:@"MediaInfo"])
    {
        data = [[data objectForKey:@"MediaInfo"] objectForKey:@"wordpress"];
        for (NSDictionary *articleDictionary in data)
        {
            [array addObject:[Article objectFromDictionary:articleDictionary]];
        }
    }
    return array;
}

- (NSArray *)parseOffers:(NSDictionary *)data
{
    ////3
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if([data containsKey:@"Offers"]){
        data = [data objectForKey:@"Offers"];
        for (NSDictionary *offerDictionary in data) {
            [array addObject:[Offer objectFromDictionary:offerDictionary]];
        }
    }
    return array;
}

- (NSArray *)parseAdditionalPhotos:(NSDictionary *)data
{
    ///4
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if([data containsKey:@"MediaInfo"])
    {
        data = [[data objectForKey:@"MediaInfo"] objectForKey:@"AdditionalPhotos"];
        for (NSDictionary *AdditionPhotoDictionary in data)
        {
            [array addObject:[Photo objectFromDictionary:AdditionPhotoDictionary]];
        }
    }
    return array;
}


- (NSArray *)parseMessages:(NSDictionary *)data{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if([data containsKey:@"Notification"]){
        data = [data objectForKey:@"Notification"];
        for (NSDictionary *offerDictionary in data) {
            [array addObject:[Message objectFromDictionary:offerDictionary]];
        }
    }
    return array;
}

- (NSArray *)parseNotificationAndOffers:(NSArray *)items
{
    NSMutableArray *notificationAndOffers = [NSMutableArray array];
    for (NSDictionary *dict1 in items) {
        if([[dict1 objectForKey:@"MessageType"] isEqualToString:@"N"])
        {
            [notificationAndOffers addObject:[Message objectFromDictionary:dict1]];
            
        }
        else if([[dict1 objectForKey:@"MessageType"] isEqualToString:@"O"])
        {
            [notificationAndOffers addObject:[Message objectFromDictionary:dict1]];
        }
        else if([[dict1 objectForKey:@"MessageType"] isEqualToString:@"H"])
        {
            [notificationAndOffers addObject:[Message objectFromDictionary:dict1]];
        }
    }
    
    return notificationAndOffers;
    
}



- (NSArray *)parseMessages1:(NSDictionary *)data
 {
     NSMutableArray *array = [[NSMutableArray alloc] init];
     if([data containsKey:@"NotificationAndOffers"])
     {
         data = [data objectForKey:@"NotificationAndOffers"];
         for (NSDictionary *offerDictionary in data)
         {
             [array addObject:[Message objectFromDictionary:offerDictionary]];
         }
     }
     return array;
 }
- (NSArray *)parseOffers1:(NSDictionary *)data
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSLog(@"datakey %@",data);
    
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
        data=[data objectForKey:@"CommonTypes"];
        for (NSDictionary *offerDictionary in data){
            [array addObject:[CommonTypes objectFromDictionary:offerDictionary]];
        }
    }
  return array;
    
}


/*
 
 
 //- (BOOL)shouldAutorotate
 //{
 //    return NO;
 //}
 //
 //- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
 //{
 //    return UIInterfaceOrientationIsPortrait(orientation);
 //}

 
 -(void)loadValuesofNearby
 {
 NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
 
 float lat = [[NSUserDefaults standardUserDefaults]floatForKey:@"Lattitude1"];
 float lon = [[NSUserDefaults standardUserDefaults]floatForKey:@"Longitude1"];
 
 NSLog(@"%f ,%f",lat,lon);
 
 [parameters setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"lat"];
 [parameters setObject:[NSString stringWithFormat:@"%f",lon] forKey:@"lng"];
 [Request makeRequestWithIdentifier:NEARBY_SEARCH parameters:parameters delegate:self];
 
 
 }
 
 - (void)connection:(Connection *)connection didReceiveData:(id)data
 {
 
 if([data isKindOfClass:[NSString class]])
 {
 data = [data jsonValue];
 }
 
 if(connection.connectionIdentifier == NEARBY_SEARCH)
 {
 _nearPlace = [NSMutableArray arrayWithArray:[self parseOffers:data]];
 
 }
 
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

 
 */
@end
