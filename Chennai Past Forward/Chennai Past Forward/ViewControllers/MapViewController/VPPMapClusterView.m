//
//  VPPMapClusterView.m
//  VPPLibraries
//
//  Created by Víctor on 09/12/11.

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


//this view is based on https://github.com/RVLVR/REVClusterMap

#import "VPPMapClusterView.h"
#import "VPPMapCluster.h"
#import <QuartzCore/QuartzCore.h>
#import "CHAnnotationView.h"
#import "MapViewController.h"

@implementation VPPMapClusterView



- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
    {
        self.userInteractionEnabled   = YES;
        UITapGestureRecognizer *ClusterTap =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleSingleTap:)];
        CLLocationCoordinate2D coord=[annotation coordinate];
        NSLog(@"annotation coordinate %f",coord.latitude);
        NSLog(@"annotation coordinate %f",coord.longitude);
        
        ClusterTap.delegate=self;
        ClusterTap.numberOfTapsRequired=1;
        ClusterTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:ClusterTap];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _button.userInteractionEnabled = YES;
        _button.titleLabel.text=@"test";
        _button.tag=1;
        [dictionary setObject:annotation forKey:_button];
        //[_button addTarget:self
                 //   action:@selector(myAction:)
          // forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_label];
        //[self addSubview:_button];
        if ([annotation isKindOfClass:[VPPMapCluster class]]) {
            self.title = [NSString stringWithFormat:@"%lu",(unsigned long)[[(VPPMapCluster*)annotation annotations] count]];
        }
       
        _label.textColor = [UIColor whiteColor];
        _label.backgroundColor = [UIColor colorWithRed:0.416 green:0.098 blue:0.122 alpha:1];
        _label.font = [UIFont boldSystemFontOfSize:11];
        _label.shadowColor = [UIColor blackColor];
        _label.shadowOffset = CGSizeMake(0,-1);
        _label.layer.cornerRadius = 20;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.layer.borderWidth = 2;
        _label.clipsToBounds = YES;
        _label.layer.masksToBounds = YES;
        _label.layer.borderColor = [[UIColor whiteColor] CGColor];
        _label.userInteractionEnabled = YES;
        
    }
    return self;
}
-(void)initialize
{
   dictionary = [NSMutableDictionary dictionary];
}
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"Touch ......");

}
-(IBAction)myAction:(id)sender
{
    CLLocationCoordinate2D coord=[[dictionary objectForKey:sender] coordinate];
    NSLog(@"annotation coordinatee %f",coord.latitude);
    NSLog(@"annotation coordinatee %f",coord.longitude);
   //NSLog(@"SENDER TAG %@",[dictionary objectForKey:@"key"]) ;
    
}

- (void) setTitle:(NSString *)title {
    _label.text = title;
}

- (NSString *) title {
    return _label.text;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}


@end
