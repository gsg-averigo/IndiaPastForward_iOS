//
//  PreviewViewController.h
//  Chennai Past Forward
//
//  Created by BTS on 11/01/16.
//  Copyright (c) 2016 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabsViewController.h"
#import "RootViewController.h"
#import "HomeViewController.h"
#import "AlertView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DetailViewController.h"

typedef enum DETAIL
{
    DETAIL_GUID
    
}DETAIL;



@class RootViewController,HomeViewController,TabsViewController,DetailViewController;
@interface PreviewViewController : UIViewController<MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UIImageView *pushimage;
     NSArray *menuTitles;
     NSArray *menuIcons;
     UIImage    *imageScreenshot;
    IBOutlet UIImageView *tempImg;
    IBOutlet UILabel *tempDesc;
    __weak IBOutlet UIWebView *webView;

    __weak IBOutlet UITextView *tempTxtView;
    IBOutlet UIView *mainView;
    IBOutlet UILabel *tempName;

    IBOutlet UIView *drawingView;
    IBOutlet UITextView *tempText;
    IBOutlet UIView *writingView;
    IBOutlet UIImageView *tempImgView1;
    NSInteger a;

    IBOutlet UIButton *drawingBtn;
    IBOutlet UIButton *writingBtn;
    UIButton *drawingBtn1;
     UIButton *writingBtn1;
    IBOutlet UIView *alertAction;
    NSInteger bac;
}
@property (nonatomic) BOOL isPresented;
@property (strong, nonatomic) TabsViewController *tabsViewController;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong,nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSMutableArray *heritagePlaces;
@property (strong, nonatomic) NSMutableArray *AdditionalPhotos;
@property (strong, nonatomic) NSMutableArray *viewControllers;




@property (nonatomic) DETAIL detailType;
@property (strong, nonatomic) NSString *guid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *lblTextView;
@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSData *data1;
@property (strong, nonatomic) NSData *screendata;
@property (strong, nonatomic) NSString *moretext;
@property (strong, nonatomic) NSURL *imgUrl;

- (IBAction)presentMenuButtonTapped:(UIButton *)sender;

@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) NSArray *options;

#pragma mark - button Actions
//- (IBAction)fbShareAction:(id)sender;
//- (IBAction)gmailShareAction:(id)sender;
//- (IBAction)backAction:(id)sender;




@end
