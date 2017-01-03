//
//  ScribblingViewController.h
//  Chennai Past Forward
//
//  Created by BTS on 14/01/16.
//  Copyright (c) 2016 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabsViewController.h"
#import "RootViewController.h"
#import "DetailViewController.h"
#import "PreviewViewController.h"
#import "DAScratchPadView.h"
#import <QuartzCore/QuartzCore.h>
#import "ACEDrawingView.h"

@class RootViewController,TabsViewController;
@interface ScribblingViewController : UIViewController
{
    
    IBOutlet DAScratchPadView *scrachView;
    IBOutlet ACEDrawingView *drawingView;
    
    IBOutlet UIButton *color2;
}
@property (strong, nonatomic) IBOutlet UIButton *color1;
@property (strong, nonatomic) TabsViewController *tabsViewController;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) NSMutableArray *heritagePlaces;
- (IBAction)penAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *colorView;

- (IBAction)setColor:(id)sender;

- (IBAction)eraserAction:(id)sender;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSData   *imgdata;
@property (strong, nonatomic)NSURL *urlString;
@property (strong, nonatomic) NSData   *screendata;
@property (strong, nonatomic) NSData *scrachData1;
- (IBAction)previewAction:(id)sender;
@end
