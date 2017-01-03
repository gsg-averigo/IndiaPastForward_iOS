
//
//  MapViewController.m
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import "MapViewController.h"
#import "RootViewController.h"
#import "HomeViewController.h"
#import "TabsViewController.h"
#import "DetailViewController.h"
#import "EnquiryPhotoViewController.h"
#import "HeritagePlace.h"
#import "Request.h"
#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue])
#import "UIDevice+IdentifierAddition.h"
#import "Reachability.h"
#import "HeritageBuildingInfo.h"
#import "NearByLocation.h"
#import "CHAnnotationView.h"
#import "CalloutAnnotation.h"
#import "CustomAnnotation.h"
#import "ConnectionIdentifier.h"
#import "Connection.h"
#import "VPPMapClusterView.h"
#import "NSObject+Parser.h"
#import "DatabaseHelper.h"

#define GEORGIA_TECH_LATITUDE 33.777328	
#define GEORGIA_TECH_LONGITUDE -84.397348
#define ZOOM_LEVEL 14

@interface MapViewController ()
{
    UITapGestureRecognizer *tapGesture;
  
}

@end

@implementation MapViewController
@synthesize addition,titleLabel;

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

- (id)init
{
    if (IPAD)
    {
        self = [super initWithNibName:@"MapViewController~iPad" bundle:nil];
    }
    else
    {
        self = [super initWithNibName:@"MapViewController" bundle:nil];
    }
    
    if(self)
    {
        
    }
    return self;
}


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    _count=0;
    NSLog(@"the additiom %@", addition);
    [VPPMapClusterView initialize];
    [self startSignificantChangeUpdates];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"ClusterClicked"
                                               object:nil];
    
    if(IS_OS_8_OR_LATER)
    {
    [self.locationManager requestAlwaysAuthorization];
    }
    //[self.view insertSubview:self.enquiry_btn aboveSubview:_mkMapView];
    [self.locationManager startUpdatingLocation];
     _mkMapView.showsUserLocation=YES;
    titleLabel.hidden = YES;
    StateName=@"";
    _isTN=YES;
    [self.mkMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self.mkMapView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
    [self.view addGestureRecognizer:tapGesture];
//    [self performSelector:@selector(zoomInToMyLocation)
//               withObject:nil
//               afterDelay:5];
    _mkMapView.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    UIPinchGestureRecognizer *swipe = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(swiped:)];
    //[self.view addGestureRecognizer:swipe];
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"MapAnnotation"] == 1000)
    {
        {
        //_locationBtn.hidden = YES;
        //[_mapBtn setUserInteractionEnabled:YES];
        //_mapBtn.hidden = NO;
        }
    }
    swipe.delegate = self;
    
}
- (void)receivedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"ClusterClicked"]) {
        self.showDistance=YES;
        CLLocation *loc = [[notification userInfo] valueForKey:@"Location"];
        city_lat=loc.coordinate.latitude;
        city_long=loc.coordinate.longitude;
            NSLog(@"latitude = %f, longitude = %f",loc.coordinate.latitude, loc.coordinate.longitude);
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        [geocoder reverseGeocodeLocation:loc
                       completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (error){
                 NSLog(@"Geocode failed with error: %@", error);
                 return;
             }
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
             NSLog(@"locality %@",  placemark.locality);
             NSLog(@"postalCode %@",placemark.postalCode);
             NSLog(@"City %@",      placemark.subAdministrativeArea);
             NSLog(@"State %@",     placemark.administrativeArea);
             NSString *city = [NSString stringWithFormat:@"%@",placemark.subAdministrativeArea];
             state = [NSString stringWithFormat:@"%@",placemark.administrativeArea];
             if ([state isEqualToString:@"(null)"]||[city isEqualToString:@"(null)"])
             {
                 NSLog(@"Valus are null so titleLable is not shown");
                 label = [NSString stringWithFormat:@"Fetching Location..."];
                 titleLabel.hidden = NO;
                 
             }
             else
             {
                 label = [NSString stringWithFormat:@"%@",state];
                 titleLabel.hidden = NO;
             }
             [titleLabel setText:label];
             if([label isEqualToString:@" Tamil Nadu"])
             {
                 _isTN=YES;
             }
             else{
                 _isTN=NO;
             }
             self.showDistance=YES;

             NSLog(@"label%@",label);
             NSLog(_isTN? @"isIndiaYes" : @"isIndiaNo");
             [[NSUserDefaults standardUserDefaults]setObject:label forKey:@"StateName"];
             NSString *StateName_pref=[[NSUserDefaults standardUserDefaults]objectForKey:@"StateName"];
             NSLog(@"statename pref %@,%@",StateName_pref,StateName);
             //![StateName isEqualToString:StateName_pref]&&
             if(StateName!=nil&&StateName_pref!=nil&&self.homeViewController.isIndia)
             {
                 StateName=StateName_pref;
                 NSString *email    =[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] ;
                 NSString *deviceId =[[UIDevice currentDevice] uniqueDeviceIdentifier];
                 NSString *lat      =[NSString stringWithFormat:@"%f",loc.coordinate.latitude];
                 NSString *lon      =[NSString stringWithFormat:@"%f",loc.coordinate.longitude];
                 NSString *strLang1 =[NSString stringWithFormat:@""];
                 NSString *distance =[NSString stringWithFormat:@"no"];
                 NSString *state1   =[NSString stringWithFormat:@"%@",StateName];
                 NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:email, @"strEmailID",deviceId,@"strDeviceID",lat,@"strLatitude",lon,@"strLongitude",strLang1,@"strLanguageCode",distance,@"distance",state1,@"StateName", nil];
                 [Request makeRequestWithIdentifier:INDIA_HERITAGE parameters:parameters delegate:self];
                 self.homeViewController.tabsViewController.showtab=NO;
                 [self.homeViewController.tabsViewController reloadHeritagePlaces];
                 //self.homeViewController.searchBy = @"IndiaMap";
                 [self.homeViewController.tabsViewController reloadNearByPlaces];
                 isCurrentLocation = NO;
                 isMap = YES;
                 [self stopSignificantChangeUpdates];
             }

         }];
       titleLabel.hidden = NO;

        }

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)swiped:(UIPinchGestureRecognizer *)gesture
{
    
    NSLog(@"Swiped");
    if(!nearby)
    {
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"MapAnnotation"] == 1000)
    {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.mkMapView.centerCoordinate.latitude, self.mkMapView.centerCoordinate.longitude);
        CGFloat txtLatitude = coord.latitude;
        CGFloat txtLongitude = coord.longitude;
        NSLog(@"%f %f",txtLatitude,txtLongitude);
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:txtLatitude longitude:txtLongitude];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&amp;sensor=false",txtLatitude,txtLongitude];
            NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&key=AIzaSyD27TJ_R_t7ykDUJOknG9g7LUKpIupzJPY",txtLatitude,txtLongitude];
        NSLog(@"url string %@",urlString);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSURLResponse *response = nil;
        NSError *requestError = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
        NSString *responseString = [[NSString alloc] initWithData: responseData encoding:NSUTF8StringEncoding];
        NSLog(@"response string %@",responseString);
        NSData *objectData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
            

         });
       // if ([json count]!=0) {
            
            if ([[json valueForKey:@"status"] isEqualToString:@"OK"] ) {
                NSArray *resultsArray = [json valueForKey:@"results"];
                NSString *address = nil;
                
                if ([resultsArray count]!=0) {
                    address = [[resultsArray objectAtIndex:0] valueForKey:@"formatted_address"];
                    NSLog(@"FORMATTED ADDRESS %@",address);
                    NSArray *strings = [address componentsSeparatedByString:@","];
                    NSMutableString *city;
                    if([strings count]>1)
                    {
                    city=[strings objectAtIndex:[strings count]-2];
                        NSRange range= [city rangeOfString: @" " options: NSBackwardsSearch];
                        NSString* str1= [city substringToIndex: range.location];
                        
                        if(![str1 isEqualToString:@"unnamed"])
                        {
                            label = [NSString stringWithFormat:@"%@",str1];
                        }
                        else{
                            label = [NSString stringWithFormat:@"Fetching..."];
                        }
                        titleLabel.hidden = NO;
                        NSLog(@"formatted address %@",address);
                    }
                    else
                    {
                    city=[strings objectAtIndex:[strings count]-1];
                        label = [NSString stringWithFormat:@"%@",city];
                        titleLabel.hidden = NO;

                    }
                   
                    
                                    }
            }
            else{
                CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
                [geocoder reverseGeocodeLocation:loc
                               completionHandler:^(NSArray *placemarks, NSError *error)
                 {
                     if (error){
                         NSLog(@"Geocode failed with error: %@", error);
                         return;
                     }
                     CLPlacemark *placemark = [placemarks objectAtIndex:0];
                     NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
                     NSLog(@"locality %@",  placemark.locality);
                     NSLog(@"postalCode %@",placemark.postalCode);
                     NSLog(@"City %@",      placemark.subAdministrativeArea);
                     NSLog(@"State %@",     placemark.administrativeArea);
                     NSString *city = [NSString stringWithFormat:@"%@",placemark.subAdministrativeArea];
                     state = [NSString stringWithFormat:@"%@",placemark.administrativeArea];
                     if ([state isEqualToString:@"(null)"]||[city isEqualToString:@"(null)"])
                     {
                         NSLog(@"Valus are null so titleLable is not shown");
                         
                     }
                     else
                     {
                        label = [NSString stringWithFormat:@"%@",state];
                         titleLabel.hidden = NO;
                     }
                 }];

                
            }
        

        [titleLabel setText:label];
        if([label isEqualToString:@" Tamil Nadu"])
        {
            _isTN=YES;
        }
        else{
            _isTN=NO;
        }
        NSLog(@"label%@",label);
        NSLog(_isTN? @"isIndiaYes" : @"isIndiaNo");
        [[NSUserDefaults standardUserDefaults]setObject:label forKey:@"StateName"];
        NSString *StateName_pref=[[NSUserDefaults standardUserDefaults]objectForKey:@"StateName"];
        NSLog(@"statename pref %@,%@",StateName_pref,StateName);
        
        if(![StateName isEqualToString:StateName_pref]&&StateName!=nil&&StateName_pref!=nil&&self.homeViewController.isIndia)
        {
            StateName=StateName_pref;
            NSString *email    =[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] ;
            NSString *deviceId =[[UIDevice currentDevice] uniqueDeviceIdentifier];
            NSString *lat      =[NSString stringWithFormat:@"%f",txtLatitude];
            NSString *lon      =[NSString stringWithFormat:@"%f",txtLongitude];
            NSString *strLang1 =[NSString stringWithFormat:@""];
            NSString *distance =[NSString stringWithFormat:@"no"];
            NSString *state1   =[NSString stringWithFormat:@"%@",StateName];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:email, @"strEmailID",deviceId,@"strDeviceID",lat,@"strLatitude",lon,@"strLongitude",strLang1,@"strLanguageCode",distance,@"distance",state1,@"StateName", nil];
            [Request makeRequestWithIdentifier:INDIA_HERITAGE parameters:parameters delegate:self];
            self.homeViewController.tabsViewController.showtab=NO;
            [self.homeViewController.tabsViewController reloadHeritagePlaces];
             //self.homeViewController.searchBy = @"IndiaMap";
            [self.homeViewController.tabsViewController reloadNearByPlaces];
            isCurrentLocation = NO;
            isMap = YES;
            [self stopSignificantChangeUpdates];
        }
        [[NSUserDefaults standardUserDefaults]setObject:@"Y" forKey:@"MapTap"];
        
    
    }
}
}
- (void) tonsOfPins:(NSArray *)array
{
    NSMutableArray *tempPlaces=[[NSMutableArray alloc] initWithCapacity:0];
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"MapAnnotation"] == 1000)
    {
        
        NSMutableDictionary *dict= [[NSMutableDictionary alloc]init];
        NSLog(@"array count %@",[array objectAtIndex:0]);
        if([self connected]&&[self.homeViewController.tabsViewController.heritagePlaces count]!=0)
        {
            _mh.fromdatabase = NO;
            for (int i = 0; i<[array count];i++)
        {
            HeritagePlace *heritage = [array objectAtIndex:i];
            NSLog(@"Heritage %@",heritage);
            MapAnnotationExample *place= [[MapAnnotationExample alloc] init];
            NSLog(@"heritage.longitude:%f",heritage.longitude);
            
            CGFloat lang = (CGFloat)heritage.longitude;
            CGFloat lat = (CGFloat)heritage.latitude;
            NSLog(@"lang %f",lang);
            place.coordinate = CLLocationCoordinate2DMake(lat, lang);
            [place setTitle:heritage.name];
            dict[@"Longitude"] = @(lang);
            dict[@"Lattitude"] = @(lat);
            [tempPlaces addObject:place];
        }
        }
        else{
            _mh.fromdatabase = YES;
            for (NSDictionary *dict in array)
            {
                //HomeList *h_list = [[HomeList alloc] init];
                //HeritagePlace *heritage;
                 MapAnnotationExample *place= [[MapAnnotationExample alloc] init];
                CGFloat lang = [[dict valueForKey:@"longitude"]doubleValue ];
                CGFloat lat = [[dict valueForKey:@"latitude"]doubleValue ];
                place.coordinate = CLLocationCoordinate2DMake(lat, lang);
                [place setTitle:[dict valueForKey:@"name"]];
                //dict[@"Longitude"] = @(lang);
                //dict[@"Lattitude"] = @(lat);
                [tempPlaces addObject:place];
            }
        }
        NSLog(@"annotations ==>");
        if([self.nearby_str isEqualToString:@"home"])
        {
        _mh.shouldClusterPins = YES;
        }
        else{
        _mh.shouldClusterPins = NO;
        }
       
        [_mh setMapAnnotations:tempPlaces];
        if (array.count !=0)
        {
            [_mh arrayvalue:array];
        }
        
    }
    else
    {
        NSMutableDictionary *dict= [[NSMutableDictionary alloc]init];
        for (int i = 0; i<[array count];i++)
        {
            HeritagePlace *heritage = [array objectAtIndex:i];
            NSLog(@"Heritage %@",heritage);

            MapAnnotationExample *place= [[MapAnnotationExample alloc] init];
            CGFloat lang = heritage.longitude;
            CGFloat lat = heritage.latitude;
            NSLog(@"nearby lang %f",heritage.longitude);
            place.coordinate = CLLocationCoordinate2DMake(lat, lang);
            [place setTitle:heritage.name];
            
            dict[@"Longitude"] = @(lang);
            dict[@"Lattitude"] = @(lat);
            [tempPlaces addObject:place];
        }
        NSLog(@"annotations ==>");
        if([self.nearby_str isEqualToString:@"home"])
        {
            _mh.shouldClusterPins = YES;
        }
        else{
            _mh.shouldClusterPins = NO;
        }

        [_mh setMapAnnotations:tempPlaces];
        if (array !=0)
        {
            [_mh arrayvalue:array];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self startSignificantChangeUpdates];
//    [self removeAllLocationMarkers];
  
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)clusterMap:(NSArray *)array
{
    _mh = [VPPMapHelper VPPMapHelperForMapView:self.mkMapView pinAnnotationColor:MKPinAnnotationColorGreen  centersOnUserLocation:NO showsDisclosureButton:YES  delegate:self];
    [_mh setRootViewController:self.rootViewController];
    _mh.userCanDropPin = YES;
    _mh.allowMultipleUserPins = YES;
    _mh.pinDroppedByUserClass = [MapAnnotationExample class];
    _mh.heritagePlaces_=self.homeViewController.tabsViewController.heritagePlaces;
    _mh.addition=self.addition;
    NSLog(@"no of pins: %lu",(unsigned long)[array count]);
    [self tonsOfPins:array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Screen Rotations


#pragma mark -

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark -

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(self.location == nil)
    {
        self.location = [locations lastObject];
        NSLog(@"Coordinate Latitude:%f",self.location.coordinate.latitude);
        NSLog(@"Coordinate Longitude:%f",self.location.coordinate.longitude);
        
        [[NSUserDefaults standardUserDefaults]setFloat:_location.coordinate.latitude forKey:@"Lattitude"];		        NSLog(@"Coordinate Longitude:%f",self.location.coordinate.longitude);
        [[NSUserDefaults standardUserDefaults]setFloat:_location.coordinate.longitude forKey:@"Longitude"];
        
        
        NSMutableDictionary *parameters1 = [[NSMutableDictionary alloc] init];
                 [parameters1 setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
                [parameters1 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
                  [parameters1 setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.latitude] forKey:@"strLatitude"];
                 [parameters1 setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.longitude] forKey:@"strLongitude"];
                [Request makeRequestWithIdentifier:SEARCH_LATLONG parameters:parameters1 delegate:self.homeViewController];
        NSString *email =[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] ;
        NSString *deviceId =[[UIDevice currentDevice] uniqueDeviceIdentifier];
        NSString *lat = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Lattitude"]];
        NSString *lon = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Longitude"]];
        NSString *strLang1 = [NSString stringWithFormat:@""];
        NSString *distance = [NSString stringWithFormat:@"yes"];
        NSString *state1 = [NSString stringWithFormat:@""];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:email, @"strEmailID",deviceId,@"strDeviceID",lat,@"strLatitude",lon,@"strLongitude",strLang1,@"strLanguageCode",distance,@"distance",state1,@"StateName", nil];
        [Request makeRequestWithIdentifier:INDIA_HERITAGE parameters:parameters delegate:self.homeViewController];
        //[self.homeViewController.tabsViewController reloadNearByPlaces];
        self.homeViewController.tabsViewController.showtab=NO;
        [self.homeViewController.tabsViewController reloadHeritagePlaces];

    }
        //[self.homeViewController.tabsViewController reloadHeritagePlaces];
    
    [self stopSignificantChangeUpdates];
//    if(self.location == nil)
//           {
//            self.location = [locations lastObject];
//            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//            [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
//            [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
//            [parameters setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.latitude] forKey:@"strLatitude"];
//            [parameters setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.longitude] forKey:@"strLongitude"];
//            [Request makeRequestWithIdentifier:SEARCH_LATLONG parameters:parameters delegate:self.homeViewController];
//         //[self.homeViewController.tabsViewController reloadHeritagePlaces];
//   
//
//    
//    [self.homeViewController.tabsViewController reloadNearByPlaces];
//               }
//    [self stopSignificantChangeUpdates];

    [[NSUserDefaults standardUserDefaults]setFloat:_location.coordinate.latitude forKey:@"Lattitude"];
    [[NSUserDefaults standardUserDefaults]setFloat:_location.coordinate.longitude forKey:@"Longitude"];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
    [parameters setObject:@"13.058" forKey:@"strLatitude"];
    [parameters setObject:@"80.264" forKey:@"strLongitude"];
    [Request makeRequestWithIdentifier:SEARCH_LATLONG parameters:parameters delegate:self.homeViewController];
    [self.homeViewController.tabsViewController reloadHeritagePlaces];
    self.homeViewController.tabsViewController.showtab=NO;
}


#pragma mark -

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    UIView *removeView;
    while((removeView = [self.view viewWithTag:999]) != nil)
    {
        [removeView removeFromSuperview];
    }
    
     NSLog(@"MapAnnotation ====>>>>>%ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"MapAnnotation"]);
    
    CHAnnotationView *annotationView= nil;
  
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"MapAnnotation"] == 1000)
    {
        static NSString  * identifier = @"CHAnnotationView";
//        if ([annotation isKindOfClass:[MKUserLocation class]])
//        {
//            return nil;
//        }
        annotationView = (CHAnnotationView *)[_mkMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        [annotationView removeFromSuperview];
        
//        if([annotation isKindOfClass: [MKUserLocation class]])
//            return nil;

        if(annotation != mapView.userLocation)
        {
 
            UILabel *label = (UILabel *)[annotationView viewWithTag:101];

            
            if ( annotationView == nil )
            {
                annotationView = [[CHAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
                annotationView.canShowCallout = YES;
                annotationView.size = CGSizeMake(8, 14);
                annotationView.image = [UIImage imageNamed:@"push_pin@2x.png"];
            
                label = [[UILabel alloc] initWithFrame:CGRectMake(0, -4, annotationView.width, annotationView.height - 4)];
                label.tag = 101;
                label.height = label.height;
                label.font = [UIFont boldSystemFontOfSize:11];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = [UIColor clearColor];
                [annotationView addSubview:label];
            }
            else
            {
//                    annotationView.annotation = annotation;
//                label.hidden = NO;
//                annotationView.image = [UIImage imageNamed:@"push_pin"];
//                label = (UILabel *)[annotationView viewWithTag:101];
                
                if (label == nil)
                {
                    //create and add label...
                    annotationView.image = [UIImage imageNamed:@"push_pin@2x.png"];

                    label = [[UILabel alloc] initWithFrame:CGRectMake(0, -4, annotationView.width, annotationView.height - 4)];
                    label.tag = 101;
                    label.height = label.height;
                    label.font = [UIFont boldSystemFontOfSize:11];
                    label.textColor = [UIColor whiteColor];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.backgroundColor = [UIColor clearColor];
                    [annotationView addSubview:label];
                }
                

            }
            if ([self connected])
            {
              
                for (int i = 0; i < [self.homeViewController.tabsViewController.heritagePlaces count]; i++)
                {
                    HeritagePlace *place = [_homeViewController.tabsViewController.heritagePlaces objectAtIndex:i];
                    
                    //NSLog(@"%f %f",place.latitude,place.longitude);
                   // NSLog(@"%f %f",annotation.coordinate.latitude,annotation.coordinate.longitude);
                    
                    if(annotation.coordinate.latitude == place.latitude && annotation.coordinate.longitude == place.longitude)
                    {
         
                        annotationView.image = [UIImage imageNamed:@"push_pin@2x.png"];
                        label.text = [NSString stringWithFormat:@"%d",i+1];
                        NSLog(@"Label text =====>>> %@",label.text);
                    }
                    
                }
                
            }
            else
            {
                
                for (int i = 0; i < [self.homeViewController.tabsViewController.sqliteHeritagePlaces count]; i++)
                {
                   // HeritagePlace *place = [_homeViewController.tabsViewController.sqliteHeritagePlaces objectAtIndex:i];
                    
                    //NSLog(@"%f %f",place.latitude,place.longitude);
                    NSLog(@"%f %f",annotation.coordinate.latitude,annotation.coordinate.longitude);
                    
                    if(annotation.coordinate.latitude == [[_latitude_arr objectAtIndex:i] doubleValue] && annotation.coordinate.longitude == [[_longitude_arr objectAtIndex:i] doubleValue])
                    {
                        
                        annotationView.image = [UIImage imageNamed:@"push_pin@2x.png"];
                        label.text = [NSString stringWithFormat:@"%d",i+1];
                        NSLog(@"Label text =====>>> %@",label.text);
                    }
                    
                }

//                NSLog(@"map not connected");
//                NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
//                NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] initWithEntityName:@"HeritageBuildingInfoList"];
//                _devices =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//                _devices = self.homeViewController.tabsViewController.sqliteHeritagePlaces;
//                
//                NSArray *arr  = [_devices valueForKey:@"longitude"];
//                NSArray *arr1 = [_devices valueForKey:@"latitude"];
//                for (int i = 0; i < [self.homeViewController.tabsViewController.sqliteHeritagePlaces count]; i++)
//                {
//                    NSString *str = [arr objectAtIndex:i];
//                    NSString *str1 = [arr1 objectAtIndex:i];
//                    
//                    if(annotation.coordinate.latitude == [str1 floatValue] && annotation.coordinate.longitude == [str floatValue])
//                    {
//                        annotationView.image = [UIImage imageNamed:@"push_pin"];
//                        label.text = [NSString stringWithFormat:@"%d",i+1];
//                        break;
//                    }
//                }
            }
        }
    }
    else
    {
        static NSString  * identifier = @"CHAnnotationView";
        if ([annotation isKindOfClass:[MKUserLocation class]])
        {
            return nil;
        }
        
        annotationView = (CHAnnotationView *)[_mkMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        [annotationView removeFromSuperview];
        if([annotation isKindOfClass: [MKUserLocation class]])
            return nil;
       
        UILabel *label1 = (UILabel *)[annotationView viewWithTag:101];
//        label1.hidden = YES;
        [label1 removeFromSuperview];
        
        if(annotation != mapView.userLocation)
        {
            if ( annotationView == nil )
            {
                 annotationView = [[CHAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
                annotationView.canShowCallout = YES;
                
            }
            if ([self connected])
            {
                annotationView.size = CGSizeMake(8, 14);
                annotationView.frame= CGRectMake(0.0, 0.0, annotationView.frame.size.width, annotationView.frame.size.height);
                
                if ([self.homeViewController.tabsViewController.nearPlace count] != 0)
                {
                    for (NearByLocation *place in self.homeViewController.tabsViewController.nearPlace)
                    {
                        
                        NSLog(@"%f %f",place.latitude,place.longitude);
                        NSLog(@"%f %f",annotation.coordinate.latitude,annotation.coordinate.longitude);
                        
                        if(annotation.coordinate.latitude == place.latitude && annotation.coordinate.longitude == place.longitude)
                        {
                            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                            dispatch_async(concurrentQueue, ^{
                                
                                NSString *urlString = [NSString stringWithFormat:@"%@", place.icon];
                                NSURL *imageURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                
                                NSData *image = [[NSData alloc] initWithContentsOfURL:imageURL];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    annotationView.image = [UIImage imageWithData:image];
                
                                });
                            });
                            
                            break;
                        }
                    }
                }else
                {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Nearby Places" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
            }
 
        }
    }
    
    return annotationView;

}


//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    CLLocation* initialLocation;
//    if ( !initialLocation )
//    {
//        initialLocation = userLocation.location;
//        
//        MKCoordinateRegion region;
//        region.center = mapView.userLocation.coordinate;
//        region.span = MKCoordinateSpanMake(0.1, 0.1);
//        
//        region = [mapView regionThatFits:region];
//        [mapView setRegion:region animated:YES];
//    }
//}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    UIView *removeView;
    while((removeView = [self.view viewWithTag:999]) != nil)
    {
        [removeView removeFromSuperview];
    }
    

    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"MapAnnotation"] == 1000)
    {
        if ([self connected])
        {
            [_mkMapView deselectAnnotation:view.annotation animated:YES];
         
            for (int i = 0; i<[self.homeViewController.tabsViewController.heritagePlaces count];i++)
            {
                HeritagePlace *place = [self.homeViewController.tabsViewController.heritagePlaces objectAtIndex:i];
                
                if(view.annotation.coordinate.latitude == place.latitude && view.annotation.coordinate.longitude == place.longitude)
                {
                    CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
                    [mapView setCenterCoordinate:newCenter animated:YES];
                    
                       [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tag"];
                    UIView* calloutView=[[UIView alloc]init];
                    calloutView.frame=CGRectMake(-60,-140,150,140);
                    calloutView.tag = 999;
                    calloutView.backgroundColor = [UIColor whiteColor];
                    calloutView.layer.cornerRadius = 10.0f;
                    CGRect calloutViewFrame = calloutView.frame;
                    calloutView.frame = calloutViewFrame;
                    calloutView.userInteractionEnabled = YES;
                    
                    UIImageView * carimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 150, 80)];
                    carimage.contentMode=UIViewContentModeScaleAspectFit;
                    carimage.tag=15;
                    [calloutView addSubview:carimage];
                    
                    [[NSUserDefaults standardUserDefaults]setInteger:i forKey:@"DidSelect"];
                    
                    NSLog(@"place.ThumbnailPhoto %@",place.thumbnailphoto);
                    NSString *string = [NSString stringWithFormat:@"%@",place.thumbnailphoto];
                    if (string == (id)[NSNull null] || string.length == 0 )
                    {
                        carimage.image = [UIImage imageNamed:@"thumb_stub"];
                        
                    }else
                    {
                        NSURL *imageURL = [NSURL URLWithString:[ROOT_URL stringByAppendingFormat:@"admin/uploadedFiles/%@/%@",place.heritagebuildinginfoguid, place.thumbnailphoto]];
                        [carimage setImageWithURL:imageURL];
                        
                    }
                    
                    UILabel *projecttitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 90, 150, 35)];
                    projecttitle.textAlignment = NSTextAlignmentCenter;
                    projecttitle.textColor=[UIColor blackColor];
                    projecttitle.font = [UIFont boldSystemFontOfSize:11];
                    projecttitle.numberOfLines = 2;
                    [calloutView addSubview:projecttitle];
                    projecttitle.text=place.name;
                    projecttitle.tag=14;
                    
                    
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(callDetailsView:)];
                    tap.numberOfTapsRequired = 1;
                    [calloutView addGestureRecognizer:tap];
                    [view addSubview:calloutView];
                    
                }
            }
            
        }else
        {
            [mapView deselectAnnotation:view.annotation animated:YES];
            NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
            NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] initWithEntityName:@"HeritageBuildingInfoList"];
            _devices =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            //_devices = self.homeViewController.tabsViewController.heritagePlaces;
            _devices = self.homeViewController.tabsViewController.sqliteHeritagePlaces;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tag"];
            NSArray *arr =  [_devices valueForKey:@"longitude"];
            NSArray *arr1 = [_devices valueForKey:@"latitude"];
            
            for (int i =0; i < [self.homeViewController.tabsViewController.sqliteHeritagePlaces count]; i++)
            {
                //NSString *str = [arr objectAtIndex:i];
                //NSString *str1 = [arr1 objectAtIndex:i];
                
                if(view.annotation.coordinate.latitude == [[_latitude_arr objectAtIndex:i] doubleValue] && view.annotation.coordinate.longitude == [[_longitude_arr objectAtIndex:i] doubleValue])
                {
                    CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
                    [mapView setCenterCoordinate:newCenter animated:YES];
                    
                    UIView* calloutView=[[UIView alloc]init];
                    calloutView.frame=CGRectMake(-60,-140,150,140);
                    calloutView.tag = 999;
                    calloutView.backgroundColor = [UIColor whiteColor];
                    calloutView.layer.cornerRadius = 10.0f;
                    CGRect calloutViewFrame = calloutView.frame;
                    calloutView.frame = calloutViewFrame;
                    UIImageView * carimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 150, 80)];
                    carimage.contentMode=UIViewContentModeScaleAspectFit;
                    carimage.tag=15;
                    [calloutView addSubview:carimage];
                    
                    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
                    
                    NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"HeritageBuildingInfoList" inManagedObjectContext:managedObjectContext];
                    [fetchRequest setEntity:entity1];
                    NSError *error;
                    NSArray * array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                   // NSArray *names = [_devices valueForKeyPath:@"name"];
                  [[NSUserDefaults standardUserDefaults]setInteger:i forKey:@"NotConnected"];
                    
                    if (array == nil)
                    {
                        NSLog(@"Testing: No results found");
                    }
                    else
                    {
                        NSLog(@"Testing: %lu Results found.", (unsigned long)[array count]);
                    }
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsPath = [paths objectAtIndex:0];
                    if(![[_photo_arr objectAtIndex:i] isEqual:@""])
                    {
                        NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[_photo_arr objectAtIndex:i]]];
                        NSLog(@"FILE PATH WHEN RETRIEVING %@",filePath);
                        NSData *pngData = [NSData dataWithContentsOfFile:filePath];
                        UIImage *image = [UIImage imageWithData:pngData];
                        carimage.image =image;
                    }
                    else
                    {
                        UIImage *image=[UIImage imageNamed:@"thumb_stub.png"];
                        carimage.image =image;
                    }

                    
//                     NSData * dataBytes = [[array objectAtIndex:i] profileimage];
//                     NSLog(@"Photo %@",dataBytes);
//                    if (dataBytes != nil)
//                    {
//                         carimage.image = [UIImage imageWithData:dataBytes];
//                    }else
//                    {
//                        carimage.image = [UIImage imageNamed:@"thumb_stub"];
//                    }
                    UILabel *projecttitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 90, 150, 40)];
                    projecttitle.textAlignment = NSTextAlignmentCenter;
                    projecttitle.textColor=[UIColor blackColor];
                    projecttitle.font = [UIFont boldSystemFontOfSize:11];
//                        projecttitle.font=[UIFont fontWithName:@"Arial" size:11];
                    projecttitle.numberOfLines = 2;
                    [calloutView addSubview:projecttitle];
                    projecttitle.text=[_title_arr objectAtIndex:i];
                    projecttitle.tag=14;
//                    [self boldFontForLabel:projecttitle];

                
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(callDetailsView:)];
                    tap.numberOfTapsRequired = 1;
                    [calloutView addGestureRecognizer:tap];
                     view.userInteractionEnabled = YES;
                    [view addSubview:calloutView];
                    
                }
            }
            
        }
    }
    else
    {
        NSLog(@"Map View select Annotation:%lu",(unsigned long)mapView.selectedAnnotations.count);
           [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tag"];
        [_mkMapView deselectAnnotation:view.annotation animated:YES];

        NSLog(@"MapCount:%lu",(unsigned long)self.homeViewController.tabsViewController.nearPlace.count);
        for (int i=0; i<self.homeViewController.tabsViewController.nearPlace.count; i++)
        {

              NearByLocation *modal = [self.homeViewController.tabsViewController.nearPlace objectAtIndex:i];
            
            if(view.annotation.coordinate.latitude == modal.latitude && view.annotation.coordinate.longitude == modal.longitude)
            {
           
                CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
                [mapView setCenterCoordinate:newCenter animated:YES];
                
                UIView* calloutView=[[UIView alloc]init];
                calloutView.frame=CGRectMake(-35,-140,150,140);
                calloutView.tag = 999;
                calloutView.backgroundColor = [UIColor whiteColor];
                calloutView.layer.cornerRadius = 10.0f;
                CGRect calloutViewFrame = calloutView.frame;
                calloutView.frame = calloutViewFrame;
                UIImageView * carimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 150, 80)];
                carimage.contentMode=UIViewContentModeScaleAspectFit;
                carimage.tag=15;
                [calloutView addSubview:carimage];
                
                NSString *urlString = [NSString stringWithFormat:@"%@", modal.url];

                if (urlString == (id)[NSNull null] || urlString.length == 0 )
                {
                    carimage.image = [UIImage imageNamed:@"thumb_stub"];

                }
                else
                {
                    NSURL *imageURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    [carimage setImageWithURL:imageURL];
                    
                }
                
                UILabel *projecttitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 90, 150, 35)];
                projecttitle.textAlignment = NSTextAlignmentCenter;
                projecttitle.textColor=[UIColor blackColor];
                projecttitle.font = [UIFont boldSystemFontOfSize:11];
                projecttitle.numberOfLines = 3;
                [calloutView addSubview:projecttitle];
                projecttitle.text=modal.name;
                projecttitle.tag=14;
//                projecttitle.font=[UIFont fontWithName:@"Arial" size:11];
//                [self boldFontForLabel:projecttitle];
                
                [calloutView addSubview:projecttitle];
                
                [view addSubview:calloutView];

            }
        }
    }
    
}


-(void)zoomInToMyLocation
{
    //self.location = [locations lastObject];
    
    [self.mkMapView setCenterCoordinate:self.mkMapView.userLocation.location.coordinate animated:YES];
    CLLocationDistance latitude = self.mkMapView.region.span.latitudeDelta * 128;
    CLLocationDistance longitude = self.mkMapView.region.span.longitudeDelta * 128;
    NSLog(@"zoom latitude %f",latitude);
    NSLog(@"zoom longitude %f",longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location.coordinate, latitude, longitude);
    [self.mkMapView setRegion:region animated:YES];
    [self.mkMapView setRegion:region animated:YES];
}
-(void)ZoomToRegion
{
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.mkMapView.centerCoordinate.latitude, self.mkMapView.centerCoordinate.longitude);
    CGFloat txtLatitude = coord.latitude;
    CGFloat txtLongitude = coord.longitude;
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:txtLatitude longitude:txtLongitude];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, txtLatitude, txtLongitude);
    [self.mkMapView setRegion:region animated:YES];
    [self.mkMapView setRegion:region animated:YES];
    
}
//}
- (void)callDetailsView:(UITapGestureRecognizer *)sender
{
    // do your stuff here
     NSLog(@"hi");
   
    
    MKAnnotationView *view = [[MKAnnotationView alloc]init];
    [_mkMapView deselectAnnotation:view.annotation animated:YES];

    if ([self connected])
    {
       
        NSInteger i =[[NSUserDefaults standardUserDefaults] integerForKey:@"DidSelect"];
        HeritagePlace *place = [self.homeViewController.tabsViewController.heritagePlaces objectAtIndex:i];
            
        NSInteger index = [self.homeViewController.tabsViewController.heritagePlaces indexOfObject:place];
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        [detailViewController setRootViewController:self.rootViewController];
        [detailViewController setDetailType:DETAIL_TYPE_PLACE];
        [detailViewController setDetailObject:[self.homeViewController.tabsViewController.heritagePlaces objectAtIndex:index]];
        detailViewController.firstPhotos = place.image;
        detailViewController.Photos = self.addition;
        detailViewController.fromMap=  YES;
        [detailViewController.view setSize:self.homeViewController.view.size];
        [self.rootViewController pushViewController:detailViewController animated:YES];
        
    }
    else
    {
        NSInteger i =[[NSUserDefaults standardUserDefaults] integerForKey:@"NotConnected"];
        //HeritagePlace *place = [self.homeViewController.tabsViewController.heritagePlaces objectAtIndex:i];
        NSLog(@"Integer %ld",(long)i);
        //NSInteger index = [self.homeViewController.tabsViewController.heritagePlaces indexOfObject:place];
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        [detailViewController setRootViewController:self.rootViewController];
        [detailViewController setDetailType:DETAIL_TYPE_PLACE];
        [detailViewController setDetailObject:[self.homeViewController.tabsViewController.sqliteHeritagePlaces objectAtIndex:i]];
//        detailViewController.firstPhotos =[_photo_arr objectAtIndex:i];
//        detailViewController.Photos = self.addition;
        detailViewController.nameString = [_title_arr objectAtIndex:i];
        detailViewController.webString = [_description_arr objectAtIndex:i];
        //detailViewController.PhotoString =[_photo_arr objectAtIndex:i];
        detailViewController.PhotoString=@"";
        [self.rootViewController pushViewController:detailViewController animated:YES];
        
        
        
        
    }

}


#pragma mark -

- (void)startSignificantChangeUpdates
{
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = (id<CLLocationManagerDelegate>)self;
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)stopSignificantChangeUpdates
{
    [self.locationManager stopMonitoringSignificantLocationChanges];
}


#pragma mark -

- (void)backgroundTapped:(UITapGestureRecognizer *)gesture
{
    NSLog(@"backtapped mapviewcontroller");
    [self.mkMapView setUserInteractionEnabled:YES];
    [self.view removeGestureRecognizer:gesture];
    [self.homeViewController hideTabsViewControllerAnimated:YES];
}
- (void)addLocationMarkers:(NSArray *)heritagePlaces
{
//    [self removeAllLocationMarkers];
//
//    if ([self connected])
//    {
//        for (HeritagePlace *place in heritagePlaces)
//        {
//            CLLocationCoordinate2D annotationCoord;
//            annotationCoord.latitude = place.latitude;
//            annotationCoord.longitude = place.longitude;
//            NSLog(@"%f",place.latitude);
//            NSLog(@"%f",place.longitude);
//            MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
//            annotationPoint.coordinate = annotationCoord;
//            annotationPoint.title = [NSString stringWithFormat:@"%lu. %@",[heritagePlaces indexOfObject:place] + 1, place.name];
//            [self.mkMapView addAnnotation:annotationPoint];
//        }
//    }
//    else{
//        _latitude_arr = [heritagePlaces valueForKey:@"latitude"];
//        _longitude_arr= [heritagePlaces valueForKey:@"longitude"];
//        _title_arr=[heritagePlaces valueForKey:@"name"];
//        _photo_arr=[heritagePlaces valueForKey:@"ThumbnailPhoto"];
//        _description_arr=[heritagePlaces valueForKey:@"Description"];
//        for(int i=0;i<_latitude_arr.count;i++)
//        {
//            NSLog(@"latitude in offline %@",[_latitude_arr objectAtIndex:i]);
//            CLLocationCoordinate2D annotationCoord;
//            annotationCoord.latitude =  [[_latitude_arr objectAtIndex:i] doubleValue];
//            annotationCoord.longitude = [[_longitude_arr objectAtIndex:i] doubleValue];
//            MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
//            annotationPoint.coordinate = annotationCoord;
//            //annotationPoint.title = [NSString stringWithFormat:@"%lu. %@",[title_arr indexOfObject:place] + 1, place.name];
//            annotationPoint.title=[NSString stringWithFormat:@"%d. %@",i+1,[_title_arr objectAtIndex:i]];
//            [self.mkMapView addAnnotation:annotationPoint];
//        }
//
//
//    }
    _count=0;
    nearby=NO;
    [[NSUserDefaults standardUserDefaults] setObject:@"home" forKey:@"maptype"];
    self.nearby_str=@"home";
    [self removeAllLocationMarkers];
    if([heritagePlaces count]!=0)
    {
    [self clusterMap:heritagePlaces];
    }
    
}

- (void)addLocationMarkersForPlaces:(NSArray *)nearByPlaces
{
    _count=0;
    nearby=YES;
    self.nearby_str=@"nearby";
   [self removeAllLocationMarkers];
   [self clusterMap:nearByPlaces];
        

    
    [[NSUserDefaults standardUserDefaults] setObject:@"nearby" forKey:@"maptype"];
//    [self removeAllLocationMarkers];
//    NSLog(@"nearby location markers called %lu",(unsigned long)nearByPlaces.count);
//    for (NearByLocation *place in nearByPlaces)
//    {
//    CLLocationCoordinate2D annotationCoord;
//    annotationCoord.latitude = place.latitude;
//    annotationCoord.longitude = place.longitude;
//    
//    //NSLog(@" %f",place.latitude);
//    //NSLog(@" %f",place.longitude);
//    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
//    annotationPoint.coordinate = annotationCoord;
//    annotationPoint.title = [NSString stringWithFormat:@"%@", place.name];
//    NSLog(@"Annotation title ===>>> %@",place.name);
//    [self.mkMapView addAnnotation:annotationPoint];

//    }
 }
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}



- (void)removeAllLocationMarkers
{
   // NSMutableArray * annotationsToRemove = self.mkMapView.annotations ;
    //[ annotationsToRemove removeObject:mapView.userLocation ] ;
   // [ _mkMapView removeAnnotations:annotationsToRemove ] ;

    for (VPPMapClusterView *annotation in self.mkMapView.annotations)
    {
        [_mkMapView removeAnnotation:annotation];
        [_mh.calloutView removeFromSuperview];
    }
//
//    for (MKPointAnnotation *annotationPoint in self.mkMapView.annotations)
//    {
//        [_mkMapView removeAnnotation:annotationPoint];
//    }
}
- (void) open:(id<MKAnnotation>)annotation
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tag"];
    
    MKAnnotationView *view = [[MKAnnotationView alloc]init];
    [_mkMapView deselectAnnotation:view.annotation animated:YES];
    if ([self connected])
    {
        NSInteger i =[[NSUserDefaults standardUserDefaults] integerForKey:@"DidSelect"];
        HeritagePlace *place = [_heritagePlaces objectAtIndex:i];
        
        NSInteger index = [_heritagePlaces indexOfObject:place];
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        [detailViewController setRootViewController:self.rootViewController];
        [detailViewController setDetailType:DETAIL_TYPE_PLACE];
        [detailViewController setDetailObject:[_heritagePlaces objectAtIndex:index]];
        detailViewController.firstPhotos = place.image;
        detailViewController.Photos = self.addition;
        detailViewController.heritagePlaces=_heritagePlaces;
        [detailViewController.view setSize:self.homeViewController.view.size];
        [self.rootViewController pushViewController:detailViewController animated:YES];
    }
    else
    {
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] initWithEntityName:@"HeritageBuildingInfoList"];
        _devices =[[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        _devices = _heritagePlaces;
        HeritagePlace *place;
        
        NSInteger i = [[NSUserDefaults standardUserDefaults]integerForKey:@"NotConnected"];
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        [detailViewController setRootViewController:self.rootViewController];
        [detailViewController setDetailType:DETAIL_TYPE_PLACE];
        [detailViewController setDetailObject:[_heritagePlaces objectAtIndex:i]];
        
        NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"HeritageBuildingInfoList" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity1];
        NSError *error;
        NSArray * array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (array == nil)
        {
            NSLog(@"Testing: No results found");
        }
        else
        {
            NSLog(@"Testing: %lu Results found.", (unsigned long)[array count]);
        }
        NSData * dataBytes = [[array objectAtIndex:i] profileimage];
        NSLog(@"Photo %@",dataBytes);
        detailViewController.firstPhotos = place.image;
        detailViewController.imgData = dataBytes;
        detailViewController.Photos = self.addition;
        [detailViewController.view setSize:self.homeViewController.view.size];
        [self.rootViewController pushViewController:detailViewController animated:YES];
    }
}
- (BOOL) annotationDroppedByUserShouldOpen:(id<MKAnnotation>)annotation;
{
    
    
    NSLog(@"pinch gesture working");
    return YES;
}


-(void)showIndiaMap
{
    _count=0;
    self.showDistance=NO;
    [self.locationManager stopUpdatingLocation];
    [self stopSignificantChangeUpdates];
    locationManager = nil;

    [self.mkMapView setUserInteractionEnabled:YES];
    [self.homeViewController hideTabsViewControllerAnimated:YES];
    //[_mh.calloutView removeFromSuperview];
    titleLabel.hidden = YES;
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"MapAnnotation"] == 1000)
    {
        //  _locationBtn.hidden = NO;
    }
    NSString *email =[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] ;
    NSString *deviceId =[[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSString *lat = [NSString stringWithFormat:@"%f",self.location.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",self.location.coordinate.longitude];
    NSString *strLang1 = [NSString stringWithFormat:@""];
    NSString *distance = [NSString stringWithFormat:@"no"];
    NSString *state1 = [NSString stringWithFormat:@""];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:email, @"strEmailID",deviceId,@"strDeviceID",lat,@"strLatitude",lon,@"strLongitude",strLang1,@"strLanguageCode",distance,@"distance",state1,@"StateName", nil];
    //    [Request makeRequest:INDIA_HERITAGE parameters:parameters delegate:self];
    [Request makeRequestWithIdentifier:INDIA_HERITAGE parameters:parameters delegate:self];
    //[self showloading];
    
    [[NSUserDefaults standardUserDefaults]setInteger:10 forKey:@"Adding"];
    if (IPAD)
    {
        MKCoordinateRegion mapRegion;
        mapRegion.center = CLLocationCoordinate2DMake(22.569532,87.246445);
        mapRegion.span.latitudeDelta = 35.0;
        mapRegion.span.longitudeDelta = 35.0;
        [_mkMapView setRegion:mapRegion animated: YES];
        
    } else {
        MKCoordinateRegion mapRegion;
        mapRegion.center = _mkMapView.userLocation.coordinate;
        mapRegion.center = CLLocationCoordinate2DMake(23.655502,79.684100);
        mapRegion.span.latitudeDelta = 32.0;
        mapRegion.span.longitudeDelta = 32.0;
        [_mkMapView setRegion:mapRegion animated: YES];
    }
    
    isMap = YES;
    isCurrentLocation = NO;
    NSLog(@"Finished");
    
    double delayInSeconds = 25.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [AlertView hideAlert];
        [self.activityView stopAnimating];
        [self.loadingView removeFromSuperview];
    });

    [[NSUserDefaults standardUserDefaults]setObject:@"Y" forKey:@"MapTap"];
  
}

-(void)showCurrentLocation
{
    _count=0;
    titleLabel.hidden=YES;
    self.showDistance=YES;
    [self.locationManager startUpdatingLocation];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"strDeviceID"];
    [parameters setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] forKey:@"strEmailID"];
    [parameters setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.latitude] forKey:@"strLatitude"];
    [parameters setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.longitude] forKey:@"strLongitude"];
    NSLog(@"latitude current location %f",self.location.coordinate.latitude);
    NSLog(@"longitude current location %f",self.location.coordinate.longitude);
    [Request makeRequestWithIdentifier:SEARCH_LATLONG parameters:parameters delegate:self.homeViewController];
    self.homeViewController.tabsViewController.showtab=YES;
    self.homeViewController.tabsViewController.count=0;
    [self.homeViewController.tabsViewController reloadHeritagePlaces];
   
    // self.homeViewController.searchBy = @"CurrentLocation";
    [self.homeViewController.tabsViewController reloadNearByPlaces];
    [self stopSignificantChangeUpdates];

[[NSUserDefaults standardUserDefaults]setFloat:_location.coordinate.latitude forKey:@"Lattitude"];
[[NSUserDefaults standardUserDefaults]setFloat:_location.coordinate.longitude forKey:@"Longitude"];
    isCurrentLocation = YES;
      //[self.homeViewController hideTabsViewControllerAnimated:YES];
}
-(void)showloading
{
    if(IPAD)
    {
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4,self.view.frame.size.height/3, 170, 170)];
        self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.loadingView.clipsToBounds = YES;
        self.loadingView.layer.cornerRadius = 10.0;
        self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.frame = CGRectMake(self.loadingView.frame.size.width/3+10,self.loadingView.frame.size.height/3-25,30,30);
        [self.loadingView addSubview:self.activityView];
        self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 95, 130, 22)];
        self.loadingLabel.backgroundColor = [UIColor clearColor];
        self.loadingLabel.textColor = [UIColor whiteColor];
        self.loadingLabel.adjustsFontSizeToFitWidth = YES;
        self.loadingLabel.textAlignment = UITextAlignmentCenter;
        self.loadingLabel.text = @"Loading...";
        [self.loadingView addSubview:self.loadingLabel];
        
    }
    else{
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 155, 170, 170)];
        self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.loadingView.clipsToBounds = YES;
        self.loadingView.layer.cornerRadius = 10.0;
        self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.frame = CGRectMake(self.loadingView.frame.size.width/2-15,self.loadingView.frame.size.height/3,30,30);
        [self.loadingView addSubview:self.activityView];
        self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
        self.loadingLabel.backgroundColor = [UIColor clearColor];
        self.loadingLabel.textColor = [UIColor whiteColor];
        self.loadingLabel.adjustsFontSizeToFitWidth = YES;
        self.loadingLabel.textAlignment = UITextAlignmentCenter;
        self.loadingLabel.text = @"Loading...";
        [self.loadingView addSubview:self.loadingLabel];
    }
    //self.activityView.frame=CGRectMake(self.view.frame.size.width/2,self.view.frame.size.height/3 , 30, 30);
    //[self.view addSubview:self.activityView];
    [self.view addSubview:self.loadingView];
    [self.activityView startAnimating];
   
}
- (void)connection:(Connection *)connection didReceiveData:(id)data
{
    [AlertView hideAlert];
    [self.activityView stopAnimating];
    [self.loadingView removeFromSuperview];
    if([data isKindOfClass:[NSString class]]){
        data = [data jsonValue];
    }
    
    if(connection.connectionIdentifier == INDIA_HERITAGE)
    {
        if([[data objectForKey:@"success"] boolValue])
        {
            [_heritagePlaces removeAllObjects];
            _heritagePlaces = [NSMutableArray arrayWithArray:[self parseHeritagePlaces:data]];
            if([_heritagePlaces count]!=0)
            {
            for (int i = 0; i < _heritagePlaces.count; i++)
            {
            HeritagePlace *place = [_heritagePlaces objectAtIndex:i];
            CLLocation *locA = [[CLLocation alloc] initWithLatitude:place.latitude longitude:place.longitude];
            CLLocation *locB = [[CLLocation alloc] initWithLatitude:city_lat longitude:city_long];
            CLLocationDistance distance = [locB distanceFromLocation:locA];
            float _difference=distance/1000;
            place.distance=_difference;
            }
            if (isMap == NO)
            {
            NSLog(@"No pins are added");
            }else
            {
            if(_count==0)
            {
            [self tonsOfPins:_heritagePlaces];
            _count=_count+1;
            }
            _mh.fromdatabase =NO;
            }
            [self.homeViewController.tabsViewController setHeritagePlaces:_heritagePlaces];
            [self.homeViewController.tabsViewController setHomeViewController:self.homeViewController];
            }
        }
    }
}

- (NSArray *)parseHeritagePlaces:(NSDictionary *)data
{
    
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
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"Change the value");
    
}
- (void) getAddressFromLatLon:(CLLocation *)bestLocation
{
    [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"IndiaMap"];
    
    NSLog(@"%f %f", bestLocation.coordinate.latitude, bestLocation.coordinate.longitude);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:bestLocation
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
         NSLog(@"locality %@",placemark.locality);
         NSLog(@"postalCode %@",placemark.postalCode);
         NSLog(@"City %@",placemark.subAdministrativeArea);
         NSLog(@"State %@",placemark.administrativeArea);
         NSString *city = [NSString stringWithFormat:@"%@",placemark.subAdministrativeArea];
         NSString *india = [NSString stringWithFormat:@"%@",placemark.country];
         state = [NSString stringWithFormat:@"%@",placemark.administrativeArea];
         
         if ([state isEqualToString:@"(null)"]||[city isEqualToString:@"(null)"])
         {
             NSLog(@"Valus are null so titleLable is not shown");
             //             [titleLabel setText:@"You Tapped In Sea,So Please Tap In Any Nearer Buildngs"];
         }
         else if([india isEqualToString:@"India"])
         {
             [[NSUserDefaults standardUserDefaults]setInteger:10 forKey:@"Adding"];
             NSString *label = [NSString stringWithFormat:@"%@,%@",city,state];
             titleLabel.hidden = NO;
             [titleLabel setText:label];
             
             
             NSString *email =[[NSUserDefaults standardUserDefaults] objectForKey:@"email"] ;
             NSString *deviceId =[[UIDevice currentDevice] uniqueDeviceIdentifier];
             NSString *lat = [NSString stringWithFormat:@"%f",self.location.coordinate.latitude];
             NSString *lon = [NSString stringWithFormat:@"%f",self.location.coordinate.longitude];
             NSString *strLang1 = [NSString stringWithFormat:@""];
             NSString *distance = [NSString stringWithFormat:@"no"];
             NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:email, @"strEmailID",deviceId,@"strDeviceID",lat,@"strLatitude",lon,@"strLongitude",strLang1,@"strLanguageCode",distance,@"distance",state,@"StateName", nil];
             isMap = YES;
             
             
             [Request makeRequestWithIdentifier:INDIA_HERITAGE parameters:parameters delegate:self];
             
           //[Request makeRequest:INDIA_HERITAGE parameters:parameters delegate:self];
             
         }
         else{
             
             titleLabel.hidden = YES;
         }
         
     }];
}



//- (void)backgroundTapped:(UITapGestureRecognizer *)gesture
//{
//    
//    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"MapAnnotation"]!=1000)
//    {
//        NSLog(@"Mapview size is ====>>%@",NSStringFromCGSize(CGSizeMake(_mkMapView.frame.size.width, _mkMapView.frame.size.height)));
//        NSLog(@"Callout tag value is ===>>%ld",(long)_mh.calloutView.tag);
//        [self.mkMapView setUserInteractionEnabled:YES];
//        [self.homeViewController hideTabsViewControllerAnimated:YES];
//    }else
//    {
//        CGPoint touchPoint = [gesture locationInView:_mkMapView];
//        CLLocationCoordinate2D location =
//        [_mkMapView convertPoint:touchPoint toCoordinateFromView:_mkMapView];
//        
//        NSLog(@"latitude  %f longitude %f",location.latitude,location.longitude);
//        
//        CLLocation *locationVal = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];
//        
//        NSString *str =   [[NSUserDefaults standardUserDefaults]objectForKey:@"MapTap"];
//        //        [[NSUserDefaults standardUserDefaults]setObject:@"Y" forKey:@"MapTap"];
//        
//        
//        
//        //        MKCoordinateRegion region;
//        //        //Set Zoom level using Span
//        //        MKCoordinateSpan span;
//        //        region.center=location;
//        //        region.span.latitudeDelta=_mkMapView.region.span.latitudeDelta *2;
//        //        region.span.longitudeDelta=_mkMapView.region.span.longitudeDelta *2;
//        ////        region.span=span;
//        //        [_mkMapView setRegion:region animated:TRUE];
//        
//        
//        if ([str isEqualToString:@"Y"])
//        {
//            
//            MKCoordinateRegion region;
//            region.center = location;
//            region.span.latitudeDelta = 2;
//            region.span.longitudeDelta = 2;
//            [_mkMapView setRegion:region animated:YES];
//            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"MapTap"];
//            
//        }
//        
//        [self getAddressFromLatLon:locationVal];
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                //NSLog(@"_mapbutton frame is ====>>>%@",NSStringFromCGRect(_mapBtn.frame));
//                NSLog(@"Mapview size is ====>>%@",NSStringFromCGSize(CGSizeMake(_mkMapView.frame.size.width, _mkMapView.frame.size.height)));
//                NSLog(@"Callout tag value is ===>>%ld",(long)_mh.calloutView.tag);
//                [self.mkMapView setUserInteractionEnabled:YES];
//                [self.homeViewController hideTabsViewControllerAnimated:YES];
//                
//            });
//        });
//        
//    }
//    
//    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"MapAnnotation"] == 1000)
//    {
//       // _locationBtn.hidden = NO;
//        
//    }
//}



@end
