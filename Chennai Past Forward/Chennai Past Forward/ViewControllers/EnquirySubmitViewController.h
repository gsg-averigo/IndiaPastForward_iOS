//
//  EnquirySubmitViewController.h
//  Chennai Past Forward
//
//  Created by BTS on 22/07/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "TabsViewController.h"
#import "HomeViewController.h"
#import "CustomIndicator.h"
#import "Request.h"


@class RootViewController,TabsViewController,HomeViewController;
@interface EnquirySubmitViewController : UIViewController<UINavigationControllerDelegate>

@property (strong,nonatomic) RootViewController *rootViewController;
@property (strong,nonatomic) TabsViewController *tabsViewController;
@property (strong,nonatomic) HomeViewController *homeViewController;
@property (strong,nonatomic) CustomIndicator    *activityIndicator;
@property (strong,nonatomic) IBOutlet UIScrollView *image_scroll;
@property (strong,nonatomic) IBOutlet UIView *slide_view;
@property (strong,nonatomic) IBOutlet UITextView *desc_txt;
@property (strong,nonatomic) IBOutlet UIButton *submit_btn;
@property (strong,nonatomic) IBOutlet UIButton *cancel_btn;
@property (strong,nonatomic) IBOutlet UILabel *desc_lbl;
@property (strong,nonatomic) Request *request;
@property (strong,nonatomic) NSMutableArray *image_array;
@property (strong,nonatomic) UIActivityIndicatorView *activityView;
@property (strong,nonatomic) UIView  *loadingView;
@property (strong,nonatomic) UILabel *loadingLabel;
@property (strong,nonatomic) UILabel *loadingWheel;
-(IBAction)onSubmitClick:(id)sender;
-(IBAction)onCancelClick:(id)sender;
-(void)onSubmitForm:(NSMutableArray *)image_array;




@end
