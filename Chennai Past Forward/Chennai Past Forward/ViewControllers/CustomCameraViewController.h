//
//  CustomCameraViewController.h
//  Chennai Past Forward
//
//  Created by BTS on 29/07/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "TabsViewController.h"
#import "CameraSessionView.h"

@class RootViewController,TabsViewController,ENQURY;
@interface CustomCameraViewController : UIViewController<CACameraSessionDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) TabsViewController *tabsViewController;
@property (strong, nonatomic) RootViewController *rootViewController;

@property (strong,nonatomic)  IBOutlet UIView *camera_view;
//@property(strong,nonatomic) IBOutlet UIButton *photo_btn;
//@property(strong,nonatomic) IBOutlet UIButton *library_btn;
@property (strong,nonatomic)  IBOutlet UIScrollView *image_scroll;
@property (strong,nonatomic)  IBOutlet UISegmentedControl *segment_ctrl;
@property (strong,nonatomic)  IBOutlet UIImageView *camera_img;
@property (strong,nonatomic)  UIImage *chosen_image;
@property (strong,nonatomic)  NSMutableArray *image_array;
@property int numberOfViews;
@property int segment_selected;
@property (nonatomic,strong)  CameraSessionView *cameraView;
@property (strong,nonatomic)  IBOutlet UIButton *save_btn;
@property (strong,nonatomic)  UIButton *add;


-(IBAction)segment_selected:(id)sender;
-(IBAction)onSaveClick:(id)sender;


@end
