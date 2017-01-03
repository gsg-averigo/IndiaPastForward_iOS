//
//  CHAnnotationView.h
//  Chariotz
//
//  Created by BTS on 9/29/15.
//  Copyright (c) 2015 Agiline. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CHAnnotationView : MKAnnotationView
@property(strong,nonatomic)NSString *colorflag;
@property (nonatomic, assign) BOOL haveImage;
@end
