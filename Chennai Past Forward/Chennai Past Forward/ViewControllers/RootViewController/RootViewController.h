//
//  RootViewController.h
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 22/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"
#import "DetailViewController.h"
#import <CraftARCloudImageRecognitionSDK/CraftARSDK.h>
#import <CraftARCloudImageRecognitionSDK/CraftARCloudRecognition.h>
#import "AlertView.h"

@interface RootViewController : UIViewController<EAIntroDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,ConnectionDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic)TabsViewController *tabsViewController;
@property (strong,nonatomic)MapViewController *mapViewController;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popToRootViewControllerAnimated:(BOOL)animated;
//@property (strong, nonatomic) NSString *searchBy;
//@property (strong, nonatomic) MapViewController *mapViewController;
//@property (strong, nonatomic) TabsViewController *tabsViewController;
//- (void)showTabsViewControllerAnimated:(BOOL)animated;
@property (strong, nonatomic) IBOutlet UIView *topvew;
@property (strong, nonatomic) id detailObject;

@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) CLLocation *location;

//- (void)hideTabsViewControllerAnimated:(BOOL)animated;
@end
