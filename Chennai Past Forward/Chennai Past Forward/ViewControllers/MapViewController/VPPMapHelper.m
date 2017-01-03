//
//  VPPMapHelper.m
//  VPPLibraries
//
//  Created by Víctor on 20/10/11.

// 	Copyright (c) 2012 Víctor Pena Placer (@vicpenap)
// 	http://www.victorpena.es/
// 	
// 	
// 	Permission is hereby granted, free of charge, to any person obtaining a copy 
// 	of this software and associated documentation files (the "Software"), to deal
// 	in the Software without restriction, including without limitation the rights 
// 	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// 	copies of the Software, and to permit persons to whom the Software is furnished
// 	to do so, subject to the following conditions:
// 	
// 	The above copyright notice and this permission notice shall be included in
// 	all copies or substantial portions of the Software.
// 	
// 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// 	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// 	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// 	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
// 	IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//new version 19/9

#import "VPPMapHelper.h"
#import "VPPMapCustomAnnotation.h"
#import "VPPMapCluster.h"
#import "VPPMapClusterHelper.h"
#import "VPPMapClusterView.h"
#import "Reachability.h"
#import "HeritagePlace.h"
#import "NearByLocation.h"
#import "DatabaseHelper.h"
#import "CHAnnotationView.h"
#import "UIDevice+IdentifierAddition.h"
#import "MapAnnotationExample.h"
#import "RootViewController.h"
#import "CHPinAnnotationView.h"
#import "MyButton.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#define kVPPMapHelperOpenAnnotationDelay 0.65

#define kVPPMapHelperOnePinLongitudeDelta 0.003f
#define kVPPMapHelperOnePinLatitudeDelta 0.0006f

#define kPressDuration 0.5 // in seconds


@implementation VPPMapHelper
@synthesize     mapView1;
@synthesize     delegate;
@synthesize     centersOnUserLocation;
@synthesize     showsDisclosureButton;
@synthesize     pinAnnotationColor;
@synthesize     mapRegionSpan;
@synthesize     userCanDropPin;
@synthesize     allowMultipleUserPins;
@synthesize     pinDroppedByUserClass;
@synthesize     shouldClusterPins;
@synthesize     distanceBetweenPins;
@synthesize     calloutView;
@synthesize Coordinates = _Coordinates;


#pragma mark -
#pragma mark Lifecycle
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate1 = [[UIApplication sharedApplication] delegate];
    if ([delegate1 performSelector:@selector(managedObjectContext)]) {
        context = [delegate1 managedObjectContext];
    }
    return context;
}

+ (VPPMapHelper*) VPPMapHelperForMapView:(MKMapView*)mapView 
                      pinAnnotationColor:(MKPinAnnotationColor)annotationColor 
                   centersOnUserLocation:(BOOL)centersOnUserLocation 
                   showsDisclosureButton:(BOOL)showsDisclosureButton 
                                delegate:(id<VPPMapHelperDelegate>)delegate {
	// sets up the map
	VPPMapHelper *mh = [[VPPMapHelper alloc] init];
	mh->_userPins = [[NSMutableArray alloc] init];
	// we don't want user's location
	mh.centersOnUserLocation = centersOnUserLocation;
	// we want the disclosure button
	mh.showsDisclosureButton = showsDisclosureButton;
    
    
	// green pins
	mh.pinAnnotationColor = annotationColor;
	// mapView referenced
	mh->mapView1 = mapView;
	// VPPMapHelperDelegate
	mh.delegate = delegate;
	// MKMapViewDelegate
	mapView.delegate = mh;
    mh->_unfilteredPins = [[NSMutableArray alloc] init];
    mh->_currentZoom = -1;
    mh->userCanDropPin = NO;
    
    
//    	UIPinchGestureRecognizer *lpgr = [[UIPinchGestureRecognizer alloc]
//    										  initWithTarget:mh action:@selector(handleLongPress:)];
//        [lpgr setDelaysTouchesBegan:YES];
//    
//    	[mh.mapView1 addGestureRecognizer:lpgr];

	return mh;
}

#pragma mark - Help stuff


- (void)handleLongPress:(UIPinchGestureRecognizer *)gestureRecognizer
{
    
    
    gestureRecognizer.scale = 1.0;
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan
        || self.userCanDropPin == NO) {
        return;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView1];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView1 convertPoint:touchPoint toCoordinateFromView:self.mapView1];
    
    if (!self.allowMultipleUserPins) {
        for (id<MKAnnotation> ann in _userPins) {
            [self.mapView1 removeAnnotation:ann];
        }
    }
    
    id<MKAnnotation> pinDroppedByUser = [[self.pinDroppedByUserClass alloc] init];
    pinDroppedByUser.coordinate = touchMapCoordinate;
    
    BOOL open = [self.delegate annotationDroppedByUserShouldOpen:pinDroppedByUser];
    
    [self.mapView1 addAnnotation:pinDroppedByUser];
    
    if (open) {
        [self performSelector:@selector(openAnnotation:) withObject:pinDroppedByUser afterDelay:kVPPMapHelperOpenAnnotationDelay];
    }
    [_userPins addObject:pinDroppedByUser];
    
    
}


- (float) distanceBetweenPins {
    if (distanceBetweenPins == 0) {
        return kVPPMapHelperDistanceBetweenPoints;
    }
    else {
        return distanceBetweenPins;
    }
}

- (CGFloat)annotationPadding {
    return 10.0f;
}

- (CGFloat)calloutHeight {
    return 40.0f;
}


// annotation disclosured


-(void)openAnnotation:(id<MKAnnotation>)annotation
{
	[self.mapView1 selectAnnotation:annotation animated:YES];
}

- (UIImage*) resizeImageForAnnotation:(UIImage*)image
{
    return image;
    //    UIImage *annImage = [image copy];
    //    
    //    CGRect resizeRect;
    //    
    //    resizeRect.size = annImage.size;
    //    CGSize maxSize = CGRectInset(self.mapView.bounds,
    //                                 [self annotationPadding],
    //                                 [self annotationPadding]).size;
    //    maxSize.height -= [self calloutHeight];
    //    if (resizeRect.size.width > maxSize.width)
    //        resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
    //    if (resizeRect.size.height > maxSize.height)
    //        resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
    //    
    //    resizeRect.origin = (CGPoint){0.0f, 0.0f};
    //    UIGraphicsBeginImageContext(resizeRect.size);
    //    [annImage drawInRect:resizeRect];
    //    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    
    //    return resizedImage;
}

- (MKAnnotationView*) buildAnnotationViewWithAnnotation:(id<VPPMapCustomAnnotation>)annotation 
                                        reuseIdentifier:(NSString*)identifier 
                                             forMapView:(MKMapView*)theMapView {
    
    CHAnnotationView *customImageView = [[CHAnnotationView alloc] initWithAnnotation:annotation
                                                                      reuseIdentifier:identifier];
    
    
    customImageView.image = [self resizeImageForAnnotation:annotation.image];
    customImageView.opaque = NO;
    [customImageView setCanShowCallout:YES];
    
    if (self.showsDisclosureButton)
    {
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self
                        action:@selector(open:)
              forControlEvents:UIControlEventTouchUpInside];
        customImageView.rightCalloutAccessoryView = rightButton; 
    }
    
    return customImageView;
}

- (BOOL) annotationShowsDisclosureButton:(id<MKAnnotation>)annotation
{
        if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)]
        && [(id<VPPMapCustomAnnotation>)annotation respondsToSelector:@selector(showsDisclosureButton)])
    {
        id<VPPMapCustomAnnotation>cust = (id<VPPMapCustomAnnotation>)annotation;
        return cust.showsDisclosureButton;
    }
    
    return self.showsDisclosureButton;
}

- (MKAnnotationView*) buildPinAnnotationViewWithAnnotation:(id<MKAnnotation>)annotation
                                           reuseIdentifier:(NSString*)identifier 
                                                forMapView:(MKMapView*)theMapView
{
    
    
//    CHAnnotationView *annotationView= nil;
//    
//    annotationView = (CHAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//        [annotationView removeFromSuperview];
    
     CHPinAnnotationView *customPinView = [[CHPinAnnotationView alloc] initWithAnnotation:annotation
                                                                          reuseIdentifier:identifier];
    
   // [(id<VPPMapCustomAnnotation>)annotation pinAnnotationColor]
    
    if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)])
    {
        [customPinView setPinColor:[(id<VPPMapCustomAnnotation>)annotation pinAnnotationColor]];
    }
    else
    {
        [customPinView setPinColor:self.pinAnnotationColor];			
    }
    
    if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)]
        && [(id<VPPMapCustomAnnotation>)annotation opensWhenShown])
    {
        [self performSelector:@selector(openAnnotation:) withObject:annotation afterDelay:kVPPMapHelperOpenAnnotationDelay];
    }
    
    if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)] 
        && [(id<VPPMapCustomAnnotation>)annotation respondsToSelector:@selector(canShowCallout)]) {
        
        id<VPPMapCustomAnnotation> cust = (id<VPPMapCustomAnnotation>)annotation;
        customPinView.canShowCallout = cust.canShowCallout;
    }
    else {
        customPinView.canShowCallout = NO;

    }
    
    if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)] 
        && [(id<VPPMapCustomAnnotation>)annotation respondsToSelector:@selector(animatesDrop)]) {
        id<VPPMapCustomAnnotation>cust = (id<VPPMapCustomAnnotation>)annotation;
        customPinView.animatesDrop = cust.animatesDrop;      
    }
    else if (!self.shouldClusterPins) {
        [customPinView setAnimatesDrop:YES];
    }
    
    return customPinView;
}


#pragma mark -
#pragma mark MKMapViewDelegate

// configures the pin for an annotation

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	//
    CLLocationCoordinate2D coord = [annotation coordinate];
    map_count=map_count+1;
   	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		// NSLog(@"ITs user location class");
		return nil;
	}

    
    if ([annotation isKindOfClass:[VPPMapCluster class]])
    {
        if(self.shouldClusterPins)
        {
       clusterView = (VPPMapClusterView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
        
        if (!clusterView) {
            clusterView = [[VPPMapClusterView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"];            
        }
        
        clusterView.title = [NSString stringWithFormat:@"%lu",(unsigned long)[[(VPPMapCluster*)annotation annotations] count]];
           
            NSLog(@"CLUSTERVIEW TITLE %@",clusterView.title);
             clusterView.canShowCallout = NO;
            _button = [[MyButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
            _button.userInteractionEnabled = YES;
            _button.titleLabel.text=@"test";
            _button.tag=1;
            [_button addTarget:self action:@selector(myAction:)
              forControlEvents:UIControlEventTouchUpInside];
            [_button setCoordinates:coord];
            [clusterView addSubview:_button];
        return clusterView;
        }
       
    }
    
	
    // annotation must have an image instead of pin icon
    CHPinAnnotationView *imagePinView;
    imagePinView.enabled = YES;
    imagePinView.canShowCallout = NO;
    if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)] 
        && [annotation respondsToSelector:@selector(image)]
        && ((id<VPPMapCustomAnnotation>)annotation).image != nil)
    {
        static NSString *imageLocationAnnotationIdentifier = @"ImageMapAnnotationIdentifier"; 
         imagePinView= (CHPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:imageLocationAnnotationIdentifier];
        
        if (!imagePinView) {
            return [self buildAnnotationViewWithAnnotation:(id<VPPMapCustomAnnotation>)annotation
                                           reuseIdentifier:imageLocationAnnotationIdentifier 
                                                forMapView:mapView];
        }
        else
        {
            imagePinView.image = [self resizeImageForAnnotation:((id<VPPMapCustomAnnotation>)annotation).image];
            imagePinView.annotation = annotation;
        }
        
      
        return imagePinView;
    }
//Single Annotation
    CHAnnotationView *pinView = nil;
    [calloutView removeFromSuperview ];

    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"MapAnnotation"] == 1000)
    {
        [calloutView removeFromSuperview ];

        if ([annotation isKindOfClass:[MKUserLocation class]])
        {
            return nil;
        }

        static NSString *locationAnnotationIdentifier = @"MapAnnotationIdentifier";
        pinView = (CHAnnotationView *)[mapView1 dequeueReusableAnnotationViewWithIdentifier:locationAnnotationIdentifier];
        [pinView removeFromSuperview];
        if([annotation isKindOfClass: [MKUserLocation class]])
            return nil;

         if(annotation != mapView.userLocation)
         {
             UILabel *label = (UILabel *)[pinView viewWithTag:101];
             if ( pinView == nil )
             {
                 pinView = [[CHAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:locationAnnotationIdentifier];
                 
                 pinView.canShowCallout = YES;
                 pinView.size = CGSizeMake(10, 18);
                 pinView.image = [UIImage imageNamed:@"push_pin@2x.png"];
                 
                label = [[UILabel alloc] initWithFrame:CGRectMake(0, -4, pinView.width, pinView.height - 4)];
                
                 CGRect rect = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
                 NSLog(@"pinSize %@",NSStringFromCGRect(rect));
                 label.tag = 101;
                 label.height = label.height;
                 label.font = [UIFont boldSystemFontOfSize:11];
                 label.textColor = [UIColor whiteColor];
                 label.textAlignment = NSTextAlignmentCenter;
                 label.backgroundColor = [UIColor clearColor];
                 [pinView addSubview:label];
            }
             else
             {
                 if (label == nil)
                 {
                     //create and add label...
                     pinView.image = [UIImage imageNamed:@"push_pin@2x.png"];
                     
                     label = [[UILabel alloc] initWithFrame:CGRectMake(0, -4, pinView.width, pinView.height - 4)];
                     CGRect rect = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
                     NSLog(@"pinSize %@",NSStringFromCGRect(rect));
                     
                     label.tag = 101;
                     label.height = label.height;
                     label.font = [UIFont boldSystemFontOfSize:11];
                     label.textColor = [UIColor whiteColor];
                     label.textAlignment = NSTextAlignmentCenter;
                     label.backgroundColor = [UIColor clearColor];
                     [pinView addSubview:label];
                 }
             }
             // NSLog(@"heritage place count %@",self.fromdatabase);
             if ([self connected]&&!self.fromdatabase)
             {
                 NSLog(@"heritage place count %lu",(unsigned long)[heritageplaces count]);
                 for (int i = 0; i < [heritageplaces count]; i++)
                 {
                     HeritagePlace *place = [heritageplaces objectAtIndex:i];
                     // NSLog(@"%f %f",place.latitude,place.longitude);
                     // NSLog(@"%f %f",annotation.coordinate.latitude,annotation.coordinate.longitude);
                     
                     if(annotation.coordinate.latitude == place.latitude && annotation.coordinate.longitude == place.longitude)
                     {
                         
                         label.text = [NSString stringWithFormat:@"%d",i+1];
                         NSLog(@"Label text =====>>> %@",label.text);
                     }
                     
                 }
                 
             }
             else
             {
                 
                 for (int i = 0; i < [heritageplaces count]; i++)
                 {
                     // HeritagePlace *place = [_homeViewController.tabsViewController.sqliteHeritagePlaces objectAtIndex:i];
                     
                     //NSLog(@"%f %f",place.latitude,place.longitude);
                     NSDictionary *dict = [heritageplaces objectAtIndex:i];
                     CGFloat lang = [[dict valueForKey:@"longitude"]doubleValue ];
                     CGFloat lat = [[dict valueForKey:@"latitude"]doubleValue ];
                     NSLog(@"%f %f",annotation.coordinate.latitude,annotation.coordinate.longitude);
                     
                     if(annotation.coordinate.latitude == lat && annotation.coordinate.longitude == lang)
                     {
                         
                         label.text = [NSString stringWithFormat:@"%d",i+1];
                         NSLog(@"Label text =====>>> %@",label.text);
                     }
                     
                 }

             
         }
         }
    }
    else
    {
        [calloutView removeFromSuperview ];
        clusterView.removeFromSuperview;
         static NSString  * identifier = @"CHAnnotationView";
         if ([annotation isKindOfClass:[MKUserLocation class]])
         {
             return nil;
         }
         
        pinView   = (CHAnnotationView *)[mapView1 dequeueReusableAnnotationViewWithIdentifier:identifier];
         [pinView removeFromSuperview];
         if([annotation isKindOfClass: [MKUserLocation class]])
             return nil;
         
         if(annotation != mapView.userLocation)
         {
             if ( pinView == nil )
             {
                 pinView = [[CHAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
                 pinView.canShowCallout = NO;
                 
             }
             if ([self connected])
             {
                 //pinView.size = CGSizeMake(8, 14);
                 pinView.frame= CGRectMake(0.0, 0.0, pinView.frame.size.width, pinView.frame.size.height);
                 NSLog(@"nearby heritageplace size %lu",(unsigned long)[heritageplaces count]);
                 if ([heritageplaces count] != 0)
                 {
                    
                     for (NearByLocation *place in heritageplaces)
                     {
                         NSLog(@"%f %f",place.latitude,place.longitude);
                         NSLog(@"%f %f",annotation.coordinate.latitude,annotation.coordinate.longitude);
                         
                         if(annotation.coordinate.latitude == place.latitude && annotation.coordinate.longitude == place.longitude)
                         {
                                                          dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                             dispatch_async(concurrentQueue, ^{
                                 NSString *urlString = [NSString stringWithFormat:@"%@", place.icon];
                                 NSURL *imageURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                 NSLog(@"nsurl %@",imageURL);
                                 NSData *image = [[NSData alloc] initWithContentsOfURL:imageURL];
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     pinView.image = [UIImage imageWithData:image];
                                     
                                 });
                             });
                             break;
                         }
                     }
                 }else
                 {
                     UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Nearby Places" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                     //[alert show];
                 }
                 
             }
         
         }
    }
    
    if ([annotation conformsToProtocol:@protocol(VPPMapCustomAnnotation)]
        && [(id<VPPMapCustomAnnotation>)annotation opensWhenShown])
    {
        [self performSelector:@selector(openAnnotation:) withObject:annotation afterDelay:kVPPMapHelperOpenAnnotationDelay];
    }
    return pinView;

}

//-(IBAction)myAction:(id)sender
//{
////    CLLocationCoordinate2D coord=[[dictionary objectForKey:sender] coordinate];
//    
//    //NSLog(@"SENDER TAG %@",[dictionary objectForKey:@"key"]) ;
//    
//    
//}
-(void)myAction:(MyButton *)sender
{
    CLLocationCoordinate2D coord = [sender Coordinates];
    CGFloat txtLatitude  = coord.latitude;
    CGFloat txtLongitude = coord.longitude;
    NSLog(@"annotation coordinatee %f",txtLatitude);
    NSLog(@"annotation coordinatee %f",txtLongitude);
    [self ZoomToRegion:coord];
    
}
-(void)ZoomToRegion:(CLLocationCoordinate2D )coord
{
    //MKCoordinateSpan span; span.latitudeDelta = .010;
    //span.longitudeDelta = .010;
    CGFloat txtLatitude = coord.latitude;
    CGFloat txtLongitude = coord.longitude;
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:txtLatitude longitude:txtLongitude];
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate,txtLatitude,txtLongitude);
//    MKCoordinateRegion adjustedRegion = [mapView1 regionThatFits:region];
    
    [mapView1 setCenterCoordinate:loc.coordinate animated:YES];
    CLLocationDistance latitude;
    CLLocationDistance longitude;
    if(IPAD)
    {
    latitude = mapView1.region.span.latitudeDelta   * 128;
    longitude = mapView1.region.span.longitudeDelta * 128;
    }
    else
    {
    latitude = mapView1.region.span.latitudeDelta   * 20;
    longitude = mapView1.region.span.longitudeDelta * 20;
    }
    NSLog(@"zoom latitude %f",latitude);
    NSLog(@"zoom longitude %f",longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, latitude, longitude);
    
    
    [mapView1 setRegion:region animated:YES];
    [mapView1 setZoomEnabled:YES];
    NSDictionary *locationDict = [NSDictionary dictionaryWithObject:loc forKey:@"Location"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClusterClicked" object:nil userInfo:locationDict];
    
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if(calloutView.tag==1)
    {
        
    }
    
    if (calloutView.tag == 999)
    {
         [calloutView removeFromSuperview];
    }
    
    VPPMapHelper *mh = [[VPPMapHelper alloc] init];

    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"MapAnnotation"] == 1000)
    {
        [calloutView removeFromSuperview];
        NSLog(@"heritage place size %lu",(unsigned long)[self.tabsViewController.heritagePlaces count]);
        if ([self connected] && !self.fromdatabase)
        {
            [mapView1 deselectAnnotation:view.annotation animated:YES];
             
            for (int i = 0; i<[heritageplaces count];i++)
            {
                HeritagePlace *place = [heritageplaces objectAtIndex:i];
                
                if(view.annotation.coordinate.latitude == place.latitude && view.annotation.coordinate.longitude == place.longitude)
                {
                    CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
                    [mapView1 setCenterCoordinate:newCenter animated:YES];
                    
                    calloutView=[[UIView alloc]init];
                    calloutView.frame=CGRectMake(-60,-140,150,140);
                    calloutView.tag = 999;
                    calloutView.backgroundColor = [UIColor whiteColor];
                    calloutView.layer.cornerRadius = 10.0f;
                    CGRect calloutViewFrame = calloutView.frame;
                    calloutView.frame = calloutViewFrame;
                    calloutView.userInteractionEnabled = YES;
                    
                    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    rightButton.frame = CGRectMake(20, 10, 110, 80);
                    rightButton.backgroundColor = [UIColor grayColor];
                    [rightButton addTarget:self
                                    action:@selector(open:)
                          forControlEvents:UIControlEventTouchUpInside];
                    [calloutView addSubview:rightButton];
                    
                    [[NSUserDefaults standardUserDefaults]setInteger:i forKey:@"DidSelect"];
                    NSLog(@"place.ThumbnailPhoto %@",place.thumbnailphoto);
                    NSString *string = [NSString stringWithFormat:@"%@",place.thumbnailphoto];
                    if (string == (id)[NSNull null] || string.length == 0 )
                    {
                        [rightButton setBackgroundImage:[UIImage imageNamed:@"thumb_stub"] forState:UIControlStateNormal];

                        
                    }else
                    {
                        NSURL *imageURL = [NSURL URLWithString:[ROOT_URL stringByAppendingFormat:@"admin/uploadedFiles/%@/%@",place.heritagebuildinginfoguid, place.thumbnailphoto]];
                        NSData *data = [NSData dataWithContentsOfURL:imageURL];
                        UIImage *image = [UIImage imageWithData:data];
                        [rightButton setBackgroundImage:image forState:UIControlStateNormal];

                    }
                    UIButton *projecttitle = [[UIButton alloc]initWithFrame:CGRectMake(0, 90, 150, 35)];
                    projecttitle.tintColor = [UIColor blackColor];
                    [projecttitle setTitle:place.name forState:UIControlStateNormal];
                    [projecttitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [projecttitle addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
                    projecttitle.titleLabel.font = [UIFont boldSystemFontOfSize:11];
                    projecttitle.titleLabel.numberOfLines = 2;
                    [calloutView addSubview:projecttitle];
                    

                    UITapGestureRecognizer *lpgr = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:mh action:@selector(handlePress:)];
                    lpgr.numberOfTapsRequired = 1;
                    [calloutView addGestureRecognizer:lpgr];
                    [view addSubview:calloutView];
                }
            }
        }
        else{
            [mapView1 deselectAnnotation:view.annotation animated:YES];
            NSUInteger index = 0;
             for (NSDictionary *dict in heritageplaces)
            {
                
                index++;
                NSLog(@" is at index %lu",(unsigned long)index);

                //HeritagePlace *place = [heritageplaces objectAtIndex:i];
                CGFloat lang = [[dict valueForKey:@"longitude"]doubleValue ];
                CGFloat lat = [[dict valueForKey:@"latitude"]doubleValue ];
               // place.coordinate = CLLocationCoordinate2DMake(lat, lang);

                if(view.annotation.coordinate.latitude == lat && view.annotation.coordinate.longitude == lang)
                {
                    CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
                    [mapView1 setCenterCoordinate:newCenter animated:YES];
                    
                    calloutView=[[UIView alloc]init];
                    calloutView.frame=CGRectMake(-60,-140,150,140);
                    calloutView.tag = 999;
                    calloutView.backgroundColor = [UIColor whiteColor];
                    calloutView.layer.cornerRadius = 10.0f;
                    CGRect calloutViewFrame = calloutView.frame;
                    calloutView.frame = calloutViewFrame;
                    calloutView.userInteractionEnabled = YES;
                    
                    
                    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    rightButton.frame = CGRectMake(20, 10, 110, 80);
                    rightButton.backgroundColor = [UIColor grayColor];
                    [rightButton addTarget:self
                                    action:@selector(open:)
                          forControlEvents:UIControlEventTouchUpInside];
                    [calloutView addSubview:rightButton];
                    
                    [[NSUserDefaults standardUserDefaults]setInteger:index forKey:@"DidSelect"];
                    //NSLog(@"place.ThumbnailPhoto %@",place.thumbnailphoto);
                   // NSString *string = [NSString stringWithFormat:@"%@",place.thumbnailphoto];
                    NSString *string=[NSString stringWithFormat:@"%@",[dict valueForKey:@"ThumbnailPhoto"]];
                    if (string == (id)[NSNull null] || string.length == 0 )
                    {
                        [rightButton setBackgroundImage:[UIImage imageNamed:@"thumb_stub"] forState:UIControlStateNormal];
                        
                        
                        
                    }else
                    {
                        if([heritageplaces count]!=10)
                        {
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsPath = [paths objectAtIndex:0];
                        NSString *imageURL = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[dict valueForKey:@"ThumbnailPhoto"]]];
                        NSLog(@"FILE PATH WHEN RETRIEVING %@",imageURL);
                    
                       // NSURL *imageURL = [NSURL URLWithString:[ROOT_URL stringByAppendingFormat:@"uploadedFiles/%@/%@",[dict valueForKey:@"heritagebuildinginfoguid"], [dict valueForKey:@"ThumbnailPhoto"]]];
                       // NSLog(@"imageulr %@",imageURL);
                        NSData *data =  [NSData dataWithContentsOfFile:imageURL];
                        UIImage *image = [UIImage imageWithData:data];
                        [rightButton setBackgroundImage:image forState:UIControlStateNormal];
                        }
                        else{
                            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[dict valueForKey:@"ThumbnailPhoto"] ]];
                            [rightButton setBackgroundImage:image forState:UIControlStateNormal];
 
                        }
                        
                    }
                    UIButton *projecttitle = [[UIButton alloc]initWithFrame:CGRectMake(0, 90, 150, 35)];
                    projecttitle.tintColor = [UIColor blackColor];
                    [projecttitle setTitle:[dict valueForKey:@"name"] forState:UIControlStateNormal];
                    [projecttitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [projecttitle addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
                    projecttitle.titleLabel.font = [UIFont boldSystemFontOfSize:11];
                    projecttitle.titleLabel.numberOfLines = 2;
                    [calloutView addSubview:projecttitle];
                    
                    
                    UITapGestureRecognizer *lpgr = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:mh action:@selector(handlePress:)];
                    lpgr.numberOfTapsRequired = 1;
                    [calloutView addGestureRecognizer:lpgr];
                    [view addSubview:calloutView];
                }
            }

            
        }
    }
    else
    {
        [calloutView removeFromSuperview];
        
        NSLog(@"Map View select Annotation:%lu",(unsigned long)mapView.selectedAnnotations.count);
        
        [mapView deselectAnnotation:view.annotation animated:YES];
        
        NSLog(@"MapCount:%lu",(unsigned long)heritageplaces.count);
        for (int i=0;i<[heritageplaces count];i++)
        {
            NearByLocation *modal = [heritageplaces objectAtIndex:i];
            
            if(view.annotation.coordinate.latitude == modal.latitude && view.annotation.coordinate.longitude == modal.longitude)
            {
                
                CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
                [mapView setCenterCoordinate:newCenter animated:YES];
                
                calloutView=[[UIView alloc]init];
                calloutView.frame=CGRectMake(-35,-140,150,140);
//                calloutView.frame=CGRectMake(-60,-140,150,140);
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
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
                    [carimage setImage:image];
                    //[carimage setImageWithURL:imageURL];
                    
                }
                
                UILabel *projecttitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 90, 150, 35)];
                projecttitle.textAlignment = NSTextAlignmentCenter;
                projecttitle.textColor=[UIColor blackColor];
                projecttitle.font = [UIFont boldSystemFontOfSize:11];
                projecttitle.numberOfLines = 3;
                [calloutView addSubview:projecttitle];
                projecttitle.text=modal.name;
                projecttitle.tag=14;
                
                [calloutView addSubview:projecttitle];
                [view addSubview:calloutView];
                
            }
        }
    }
    
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

-(IBAction)open:(id)sender
{
    // gets the only (that's why objectAtIndex:0) annotation selected
    //[self.homeViewController.tabsViewController opendetailspage];
   // NSLog(@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"DidSelect"]);
    //NSDictionary *dict = [heritageplaces objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"DidSelect"]];
    //CGFloat lang = [[dict valueForKey:@"longitude"]doubleValue ];
   // NSLog(@"object typeb %@",dict);
   // id<MKAnnotation> anno = [heritageplaces objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"DidSelect"]];
    //id<MKAnnotation> anno= anno;
  //  [self.delegate open:anno];
    if ([self connected]&&!self.fromdatabase)
    {
        NSInteger i =[[NSUserDefaults standardUserDefaults] integerForKey:@"DidSelect"];
        HeritagePlace *place = [heritageplaces objectAtIndex:i];
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        [detailViewController setRootViewController:self.rootViewController];
        [detailViewController setDetailType:DETAIL_TYPE_PLACE];
        [detailViewController setDetailObject:[heritageplaces objectAtIndex:i]];
        NSMutableArray *newDevice = [[NSMutableArray alloc]init];
        newDevice = [heritageplaces objectAtIndex:i];
        detailViewController.placeArray = newDevice;
        detailViewController.heritagePlaces = _heritagePlaces_;
        detailViewController.fromMap=YES;
        NSLog(@"%f ",place.latitude);
        NSLog(@"%f",place.longitude);
        detailViewController.Photos=self.addition;
        //[detailViewController.view setSize:self.homeViewController.view.size];
        NSLog(@"rootviewcontroller %@",self.rootViewController);
        [self.rootViewController pushViewController:detailViewController animated:YES];
        
//        NSInteger i =[[NSUserDefaults standardUserDefaults] integerForKey:@"DidSelect"];
//        HeritagePlace *place = [heritageplaces objectAtIndex:i];
//        NSLog(@"place object %@",self.rootViewController);
//       // NSInteger index = [heritageplaces indexOfObject:i];
//        DetailViewController *detailViewController = [[DetailViewController alloc] init];
//        [detailViewController setRootViewController:self.rootViewController];
//        [detailViewController setDetailType:DETAIL_TYPE_PLACE];
//        [detailViewController setDetailObject:[heritageplaces objectAtIndex:i]];
//        detailViewController.firstPhotos = place.image;
//        detailViewController.heritagePlaces=_heritagePlaces_;
//        detailViewController.Photos = self.addition;
//        [detailViewController.view setSize:self.homeViewController.view.size];
//        [self.rootViewController pushViewController:detailViewController animated:YES];
        
        
    }
    else
    {
        NSDictionary *dict = [heritageplaces objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"DidSelect"]-1];
        NSInteger i =[[NSUserDefaults standardUserDefaults] integerForKey:@"DidSelect"]-1;
        NSLog(@"Integer %ld",(long)i);
        DetailViewController *detailViewController = [[DetailViewController alloc] init];
        [detailViewController setRootViewController:self.rootViewController];
        [detailViewController setDetailType:DETAIL_TYPE_PLACE];
        [detailViewController setDetailObject:dict];//[heritageplaces objectAtIndex:i]];
        detailViewController.nameString = [dict valueForKey:@"name"];//[_title_arr objectAtIndex:i];
        detailViewController.webString = [dict valueForKey:@"Description"];//[_description_arr objectAtIndex:i];
        detailViewController.PhotoString=@"";
         detailViewController.heritagePlaces=_heritagePlaces_;
        [self.rootViewController pushViewController:detailViewController animated:YES];
        
        
        
        
    }

    
}

- (void)handlePress:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"Touch ......");
    
    NSLog(@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"DidSelect"]);
    
    id<MKAnnotation> anno = [heritageplaces objectAtIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"DidSelect"]];
    [self.delegate open:anno];
}


- (MKCoordinateRegion) regionAccordingToAnnotations:(NSArray*)annotations
{
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    CLLocationCoordinate2D currentCoordinate;
    
    float minLatitude = -9999;
    float minLongitude = -9999;
    float maxLatitude = 9999;
    float maxLongitude = 9999;
    for (id<MKAnnotation> ann in annotations) {
        if ([ann isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        currentCoordinate = ann.coordinate;
        if (minLatitude == -9999 || minLongitude == -9999) {
            minLatitude = currentCoordinate.latitude;
            minLongitude = currentCoordinate.longitude;	
        }
        if (maxLatitude == 9999 || maxLongitude == 9999) {
            maxLatitude = currentCoordinate.latitude;
            maxLongitude = currentCoordinate.longitude;				
        }
        
        if (currentCoordinate.latitude < minLatitude) {
            minLatitude = currentCoordinate.latitude;
        }
        if (currentCoordinate.longitude < minLongitude) {
            minLongitude = currentCoordinate.longitude;
        }
        if (currentCoordinate.latitude > maxLatitude) {
            maxLatitude = currentCoordinate.latitude;
        }
        if (currentCoordinate.longitude > maxLongitude) {
            maxLongitude = currentCoordinate.longitude;
        }
    }		
    
    CLLocation *min = [[CLLocation alloc] initWithLatitude:minLatitude longitude:minLongitude];
    CLLocation *max = [[CLLocation alloc] initWithLatitude:maxLatitude longitude:maxLongitude];
    CLLocationDistance dist = [max distanceFromLocation:min];
    
    region.center.latitude = (minLatitude + maxLatitude) / 2.0;
    region.center.longitude = (minLongitude	+ maxLongitude) / 2.0;
    region.span.latitudeDelta = dist / 111319.5; // magic number !! :)
    // explanation here: http://developer.apple.com/library/ios/#documentation/MapKit/Reference/MapKitDataTypesReference/Reference/reference.html
    region.span.longitudeDelta = 0.0;

    return region;
    
}

#pragma mark - Centering map stuff

- (void)observeValueForKeyPath:(NSString *)keyPath  ofObject:(id)object change:(NSDictionary *)change  
                       context:(void *)context
{
    
    if (self.centersOnUserLocation)
    {
        [self centerMap];
    }
}

- (void) centerOnCoordinate:(CLLocationCoordinate2D)coordinate
{
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };

    region.center = coordinate;
    
    if (self.mapRegionSpan.latitudeDelta != 0.0 && self.mapRegionSpan.longitudeDelta != 0.0) {
        region.span = self.mapRegionSpan;
    }
    else {
        region.span.longitudeDelta = kVPPMapHelperLongitudeDelta;
        region.span.latitudeDelta = kVPPMapHelperLatitudeDelta;		
    }
    
    [self.mapView1 setRegion:region animated:YES];
}

- (void) centerMap
{
	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
	CLLocationCoordinate2D currentCoordinate;
	
	if (self.centersOnUserLocation)
    {
		CLLocation *userLocation = self.mapView1.userLocation.location;

		[self centerOnCoordinate:userLocation.coordinate];
        
		return;
	}
	
	else if ([self.mapView1.annotations count] > 1) {
		region = [self regionAccordingToAnnotations:self.mapView1.annotations];
    }
	
	else if ([self.mapView1.annotations count] == 1) {
		currentCoordinate = [[self.mapView1.annotations objectAtIndex:0] coordinate];
		
        region.center = currentCoordinate;
		
		region.span.longitudeDelta = kVPPMapHelperOnePinLongitudeDelta;
		region.span.latitudeDelta = kVPPMapHelperOnePinLatitudeDelta;		
	}
	
	else {
		return;
	}
	
	
	[self.mapView1 setRegion:region animated:YES];
}


#pragma mark - Clustering stuff
- (void) mapView:(MKMapView *)mmapView didAddAnnotationViews:(NSArray *)views
{
    if (_pinsToRemove != nil)
    {
        [mmapView removeAnnotations:_pinsToRemove];
        _pinsToRemove = nil;
    }
}

- (BOOL) mapViewDidZoom:(MKMapView*)mmapView
{
    if (_currentZoom == mmapView.visibleMapRect.size.width * mmapView.visibleMapRect.size.height)
    {
        NSLog(@"Zooooooooom");
        return NO;
    }
    _currentZoom = mmapView.visibleMapRect.size.width * mmapView.visibleMapRect.size.height;
    return YES;
}

- (void) mapView:(MKMapView *)mmapView regionDidChangeAnimated:(BOOL)animated
{
    
    if (self.shouldClusterPins && [_unfilteredPins count] != 0 && [self mapViewDidZoom:mmapView])
    {
        VPPMapClusterHelper *mh = [[VPPMapClusterHelper alloc] initWithMapView:self.mapView1];
        [mh clustersForAnnotations:_unfilteredPins distance:self.distanceBetweenPins completion:^(NSArray *data) {
            
            _pinsToRemove = [[NSMutableArray alloc] initWithArray:self.mapView1.annotations];
            [_pinsToRemove removeObjectsInArray:data];
            [self.mapView1 addAnnotations:data];
        }];
    }
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.mapView1.centerCoordinate.latitude, self.mapView1.centerCoordinate.longitude);
    CGFloat txtLatitude = coord.latitude;
    CGFloat txtLongitude = coord.longitude;
    NSLog(@"%f %f",txtLatitude,txtLongitude);
    if (txtLatitude == 22.569532f || txtLongitude == 87.246445)
    {
        NSLog(@"Zoom stop zooming");
    }
  
    
//    if (IPAD)
//    {
//        MKCoordinateRegion mapRegion;
//        mapRegion.center = CLLocationCoordinate2DMake(22.569532,87.246445);
//        mapRegion.span.latitudeDelta = 35.0;
//        mapRegion.span.longitudeDelta = 35.0;
//        [_mkMapView setRegion:mapRegion animated: YES];
//        
//    } else {
//        MKCoordinateRegion mapRegion;
//        mapRegion.center = _mkMapView.userLocation.coordinate;
//        mapRegion.center = CLLocationCoordinate2DMake(23.655502,79.684100);
//        mapRegion.span.latitudeDelta = 32.0;
//        mapRegion.span.longitudeDelta = 32.0;
//        [_mkMapView setRegion:mapRegion animated: YES];
//    }


}
- (void)zoomMap:(MKMapView*)mapView byDelta:(float) delta {
    
    MKCoordinateRegion region = mapView.region;
    MKCoordinateSpan span = mapView.region.span;
    span.latitudeDelta*=delta;
    span.longitudeDelta*=delta;
    region.span=span;
    [mapView setRegion:region animated:YES];
    
}

- (void) doTheReload123:(NSArray *) theArray
{
    NSMutableDictionary *dict= [[NSMutableDictionary alloc]init];
    NSMutableArray *tempPlaces=[[NSMutableArray alloc] initWithCapacity:0];

    for (int i = 0; i<[theArray count];i++)
    {
        HeritagePlace *heritage = [theArray objectAtIndex:i];
        MapAnnotationExample *place= [[MapAnnotationExample alloc] init];
        CGFloat lang = heritage.longitude;
        CGFloat lat = heritage.latitude;
        place.coordinate = CLLocationCoordinate2DMake(lat, lang);
        [place setTitle:heritage.name];
        dict[@"Longitude"] = @(lang);
        dict[@"Lattitude"] = @(lat);
        [tempPlaces addObject:place];
    }
    NSLog(@"annotations ==>");
    shouldClusterPins = YES;
    [self setMapAnnotations:tempPlaces];
//    [self arrayvalue:theArray];
   }
- (void) doTheReloadnearbyplace:(NSArray *) theArray
{
    NSMutableDictionary *dict= [[NSMutableDictionary alloc]init];
    NSMutableArray *tempPlaces=[[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i<[theArray count];i++)
    {
        HeritagePlace *heritage = [theArray objectAtIndex:i];
        MapAnnotationExample *place= [[MapAnnotationExample alloc] init];
        CGFloat lang = heritage.longitude;
        CGFloat lat = heritage.latitude;
        place.coordinate = CLLocationCoordinate2DMake(lat, lang);
        [place setTitle:heritage.name];
        dict[@"Longitude"] = @(lang);
        dict[@"Lattitude"] = @(lat);
        [tempPlaces addObject:place];
    }
    
    shouldClusterPins = NO;
    [self setMapAnnotations:tempPlaces];
    //    [self arrayvalue:theArray];
}


- (void)connection:(Connection *)connection didReceiveData:(id)data
{
    [AlertView hideAlert];
    if([data isKindOfClass:[NSString class]]){
        data = [data jsonValue];
    }

    if(connection.connectionIdentifier == INDIA_HERITAGE)
    {
       NSMutableArray *heritageplaces1 = [[NSMutableArray alloc]init];
        if([[data objectForKey:@"success"] boolValue])
        {
            [self removemarkers];
            [heritageplaces1 removeAllObjects];
            heritageplaces1 = [NSMutableArray arrayWithArray:[self parseHeritagePlaces:data]];
            [self doTheReload123:heritageplaces1];

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

- (void) getAddressFromLatLon:(CLLocation *)bestLocation
{
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
         NSLog(@"State %@",placemark.subAdministrativeArea);
         NSLog(@"State %@",placemark.administrativeArea);
         NSString *label = [NSString stringWithFormat:@"%@,%@",placemark.subAdministrativeArea,placemark.administrativeArea];
     }];
}
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated

#pragma mark - Managing annotations
// sets all annotations and initializes map.

- (void)setMapAnnotations:(NSArray*)mapAnnotations
{
	// removes all previous annotations
	NSArray *annotations = [NSArray arrayWithArray:self.mapView1.annotations];
	[self.mapView1 removeAnnotations:annotations];
	
	[self addMapAnnotations:mapAnnotations];
	
    if (self.shouldClusterPins)
    {
        [_unfilteredPins removeAllObjects];
        
           // [self.mapView1 setRegion:[self regionAccordingToAnnotations:mapAnnotations] animated:YES];
    }
    else
    {
       //[_unfilteredPins removeAllObjects];
        [self centerMap];
    }
}


// adds more annotations 
- (void)addMapAnnotations:(NSArray*)mapAnnotations
{
    [self removemarkers];
    //[doTheReload123 HeritagePlace];
    if (self.shouldClusterPins)
    {
        VPPMapClusterHelper *mh = [[VPPMapClusterHelper alloc] initWithMapView:self.mapView1];
        [mh clustersForAnnotations:mapAnnotations distance:self.distanceBetweenPins completion:^(NSArray *data)
        {
            
            [_unfilteredPins addObjectsFromArray:mapAnnotations];
            [self.mapView1 addAnnotations:data];
        }];
    }
    else
    {
//        NSMutableArray *array = [[NSMutableArray alloc] init];
//        
//    
//            for (NSDictionary *heritagePlaceDictionary in heritageplaces)
//            {
//                [array addObject:[HeritagePlace objectFromDictionary:heritagePlaceDictionary]];
//            }
//        [self doTheReloadnearbyplace:array];
         shouldClusterPins = NO;
        [self.mapView1 addAnnotations:mapAnnotations];
    }
    NSLog(@"cluster pins %lu",(unsigned long)[_unfilteredPins count]);
}

-(void)removemarkers
{
    for (VPPMapClusterView *annotation in self.mapView1.annotations)
    {
        [mapView1 removeAnnotation:annotation];
    }
}

-(void)arrayvalue :(NSMutableArray *)array
{
    heritageplaces = [[NSMutableArray alloc]init];
    [heritageplaces removeAllObjects];
    heritageplaces = [NSMutableArray arrayWithArray:array];
    NSLog(@"Heritage array count ====>>%lu",(unsigned long)heritageplaces.count);
}

@end
