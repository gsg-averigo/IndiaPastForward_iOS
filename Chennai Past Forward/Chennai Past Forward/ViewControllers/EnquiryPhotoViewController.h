//
//  EnquiryPhotoViewController.h
//  Chennai Past Forward
//
//  Created by BTS on 21/07/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import  "TabsViewController.h"
#import  "EnquirySubmitViewController.h"


@class RootViewController,TabsViewController,ENQURY;
@interface EnquiryPhotoViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>

@property (nonatomic) BOOL isPresented;
@property (strong, nonatomic) TabsViewController *tabsViewController;
@property (strong, nonatomic) RootViewController *rootViewController;


@property (strong,nonatomic) IBOutlet UISegmentedControl *segmentcontrol;
@property (strong,nonatomic) IBOutlet UIImageView *camera_img;
@property (strong,nonatomic) IBOutlet UIScrollView *image_scroll;
//@property (strong,nonatomic) IBOutlet UIBarButtonItem *save_btn;
@property (strong,nonatomic) IBOutlet UIButton *save_btn;
@property (strong,nonatomic) UIButton *add;
@property (strong,nonatomic) UIImage *chosen_image;
@property (strong,nonatomic) NSMutableArray *image_array;
@property int numberOfViews;
-(IBAction)segment_selected:(id)sender;
-(IBAction)onSaveClick:(id)sender;




@end

