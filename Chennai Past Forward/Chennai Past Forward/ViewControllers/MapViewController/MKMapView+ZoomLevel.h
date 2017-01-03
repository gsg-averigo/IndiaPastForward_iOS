//
//  MKMapView+ZoomLevel.h
//  Chennai Past Forward
//
//  Created by BTS on 25/03/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView_ZoomLevel : MKMapView


- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
