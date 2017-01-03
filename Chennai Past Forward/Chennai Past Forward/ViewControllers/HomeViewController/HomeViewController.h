//
//  HomeViewController.h
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "WSCoachMarksView.h"


@class RootViewController, MapViewController, TabsViewController;

@interface HomeViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate,WSCoachMarksViewDelegate>
{
    NSMutableArray   *Heritage_devices;
    NSMutableArray   *article_device;
    NSDictionary     *di;
    WSCoachMarksView *coachMarksView;
}
@property (strong,nonatomic) RootViewController *rootViewController;
@property (strong,nonatomic) MapViewController *mapViewController;
@property (strong,nonatomic) TabsViewController *tabsViewController;
@property (strong,nonatomic) NSArray   *coachMarks;
@property (strong,nonatomic) NSString  *searchBy;
@property (strong,nonatomic) UIButton  *Enquiry_btn;
@property (strong,nonatomic) UIButton  *Cur_location_btn;
@property (strong,nonatomic) UIButton  *India_location_btn;
@property (strong,nonatomic) UILabel   *tooltip;
@property (strong, nonatomic) NSMutableArray *btnselectArr;
@property (strong, nonatomic) NSMutableArray *dummyArr1;
@property (nonatomic,assign) BOOL isIndia;
@property (nonatomic,assign) BOOL showtab;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)showTabsViewControllerAnimated:(BOOL)animated;
- (void)hideTabsViewControllerAnimated:(BOOL)animated;
- (void)backgroundTapped:(UITapGestureRecognizer *)gesture;
- (void)hidebuttons;
- (void)showbuttons;

@end

//@class RootViewController, MapViewController, TabsViewController;
//@interface HomeViewController : UIViewController
//@property (strong, nonatomic) RootViewController *rootViewController;
//@property (strong, nonatomic) MapViewController *mapViewController;
//@property (strong, nonatomic) TabsViewController *tabsViewController;
//@property (strong, nonatomic) NSString *searchBy;
//- (void)showTabsViewControllerAnimated:(BOOL)animated;
//- (void)hideTabsViewControllerAnimated:(BOOL)animated;
//@end
