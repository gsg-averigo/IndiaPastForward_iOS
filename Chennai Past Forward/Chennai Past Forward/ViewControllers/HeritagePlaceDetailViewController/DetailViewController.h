//
//  DetailViewController.h
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabsViewController.h"
#import "HomeViewController.h"
#import "DAScratchPadView.h"
#import "PreviewViewController.h"
#import "KGModal.h"
#import "EditableViewController.h"
#import "ScribblingViewController.h"
#import "WSCoachMarksView.h"


typedef enum DETAIL_TYPE{
    DETAIL_TYPE_PLACE,
    DETAIL_TYPE_OFFER,
    DETAIL_TYPE_MESSAGE,
    DETAIL_TYPE_GUID,
    DETAIL_TYPE_BROWSE,
    DETAIL_TYPE_TWEET,
    DETAIL_TYPE_PHOTOS
}DETAIL_TYPE;


typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;



@class RootViewController,TabsViewController,HeritagePlace,HomeViewController, Offer,NextViewController;
@interface DetailViewController : UIViewController <ConnectionDelegate,UIWebViewDelegate,UIActionSheetDelegate,UITextViewDelegate,WSCoachMarksViewDelegate>
{
    IBOutlet UIButton *writeBtn;
    IBOutlet UIButton *scribBtn;
    IBOutlet UIView *nextView;
    IBOutlet UIImageView *newImageView;
    IBOutlet UILabel *newDescriptionlbl;
    IBOutlet UILabel *newNameLbl;
    IBOutlet UIView *newTopView;
    IBOutlet UIView *alertView;
    NSMutableArray *heritagePlaces;
    IBOutlet UIView *scrachPadView;
    IBOutlet DAScratchPadView *scrachView;
    IBOutlet UILabel *editLabel;
    IBOutlet UITextView *editTextView;
    __weak IBOutlet UIButton *langBtn;
    __weak IBOutlet UILabel *langLbl;
    WSCoachMarksView *coachMarksView;
}
@property (nonatomic,assign) BOOL isPostCard;
@property(strong, nonatomic) TabsViewController *tabsViewController;
@property(strong, nonatomic) RootViewController *rootViewController;
@property(strong,nonatomic) HomeViewController *homeViewController;
@property(strong, nonatomic) IBOutlet UIButton *scribllingPadAction;
@property(strong,nonatomic) NSString *scanUrl;
@property (strong,nonatomic) NSArray *coachMarks;
@property (strong, nonatomic) id detailObject;
@property (nonatomic,assign) BOOL fromMap;
@property(nonatomic) DETAIL_TYPE detailType;
@property(strong,nonatomic) NSString *HerGUID;
@property(strong,nonatomic) IBOutlet UIView * footerview;
@property(strong,nonatomic) IBOutlet UIView * browView;
@property(strong,nonatomic) IBOutlet UIView * labelView;
@property(strong,nonatomic) NSMutableArray * herplaces;
@property (strong, nonatomic) NSMutableArray *heritagePlaces;
@property(strong,nonatomic) NSMutableArray * Langauges;
@property(strong,nonatomic) NSMutableArray * Photos;
@property(strong,nonatomic) NSString * firstPhotos;
@property(strong,nonatomic)UILabel *homeLabel ;
@property(strong,nonatomic)IBOutlet UIScrollView *scrollview;
@property(strong,nonatomic)IBOutlet UIPageControl *pagecontrol;
@property NSString * global_lang;
@property NSString * LanguageFlag;
- (IBAction)relatedInfoButtonTapped:(id)sender;
-(IBAction)registerforwalk:(id)sender;
-(IBAction)sendbankcode:(id)sender;
-(IBAction)textfieldreturn:(id)sender;
@property(strong,nonatomic)IBOutlet UIWebView *browserview;
@property(strong, nonatomic) IBOutlet UIScrollView *thumbnailScrollview;
@property(strong, nonatomic) IBOutlet UIView *thumbView;

@property(strong, nonatomic) IBOutlet UIButton *nextBt;

@property(strong, nonatomic) IBOutlet UIButton *prevBt;

@property(strong, nonatomic) IBOutlet UIButton *thumbnailNextButton;
@property(strong, nonatomic) IBOutlet UIButton *thumbnailPrevButton;
@property int seqValues;
@property(nonatomic, assign) CGFloat lastContentOffset;
@property(nonatomic, assign) CGFloat lastContentOffset1;
@property(strong,nonatomic) NSString * flagString;

- (IBAction)scriblingAction:(id)sender;
- (IBAction)writtingAction:(id)sender;

@property (strong, nonatomic) NSData *imgData;
- (IBAction)nextAction:(id)sender;
- (IBAction)postCardAction:(id)sender;
- (IBAction)previewAction:(id)sender;
@property (strong, nonatomic) UINavigationController *navigationController;

#pragma mark - Writing pad
- (IBAction)setcolor:(id)sender;
- (IBAction)writinPreviewAction:(id)sender;

@property (strong, nonatomic) NSArray *options;
@property(strong,nonatomic) NSString *guid;
@property(strong,nonatomic) NSMutableArray * placeArray;

/////    For Offline

@property (strong, nonatomic)NSString *nameString;
@property (strong, nonatomic)NSString *webString;
@property (strong, nonatomic)NSData *imageViewdata;
@property (strong, nonatomic)NSString *PhotoString;
@end
