//
//  MapViewController.h
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPPMapHelper.h"
#import "MapAnnotationExample.h"
#import "VPPMapHelperDelegate.h"
#import "VPPMapHelper.h"
#import "HeritagePlacesViewController.h"

@class RootViewController, HomeViewController,HeritagePlacesViewController;
@interface MapViewController : UIViewController <MKMapViewDelegate,VPPMapHelperDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate>
{
CLLocationManager *locationManager;
NSString *state;
VPPMapHelper *_mh;
BOOL isMap;
BOOL isCurrentLocation;
NSMutableArray *arraySaved;
NSMutableArray *arrayVal;
NSMutableArray *_heritagePlaces;
BOOL nearby;
NSDictionary *json;
NSString *label;
NSString *StateName;
    float city_lat;
    float city_long;
}


@property (strong, nonatomic) IBOutlet MKMapView *mkMapView;
//@property (strong, nonatomic) IBOutlet UIButton *enquiry_btn;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) MapViewController *mapViewController;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong,nonatomic) UIView  *loadingView;
@property (strong,nonatomic) UIActivityIndicatorView *activityView;
@property (strong,nonatomic) UILabel *loadingLabel;
@property (strong,nonatomic) UILabel *loadingWheel;
@property (strong,nonatomic) NSString *state;
@property (assign,nonatomic) NSInteger *count;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property(strong,nonatomic) NSMutableArray *addition;
@property (assign,nonatomic) BOOL *isTN;
@property (assign,nonatomic) BOOL showDistance;
- (void)backgroundTapped:(UITapGestureRecognizer *)gesture;
- (void)addLocationMarkers:(NSArray *)heritagePlaces;
- (void)addLocationMarkersForPlaces:(NSArray *)heritagePlaces;
- (void)removeAllLocationMarkers;
- (void)reloadMap;
- (void)zoomInToMyLocation;
- (void)ZoomToRegion;
- (void)showIndiaMap;
- (void)showCurrentLocation;
- (void)callDetailsView:(UITapGestureRecognizer *)sender;

//-(IBAction) onEnquiryBtnClick:(id)sender;
@property (strong) NSMutableArray *devices;
@property (nonatomic, readwrite) CLLocationDegrees lat;
@property (nonatomic, readwrite) CLLocationDegrees lon;

@property (strong,nonatomic) NSArray *latitude_arr;
@property (strong,nonatomic) NSArray *longitude_arr;
@property (strong,nonatomic) NSArray *title_arr;
@property (strong,nonatomic) NSArray *photo_arr;
@property (strong,nonatomic) NSArray *description_arr;

@property (strong,nonatomic) NSString *nearby_str;


@end
