//
//  EditableViewController.h
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

@class RootViewController,TabsViewController,ENQURY;
@interface EditableViewController : UIViewController<UITextViewDelegate>

{
    IBOutlet UILabel *editableLabel;
    IBOutlet UITextView *editableTextView;
    
}
@property (strong, nonatomic) TabsViewController *tabsViewController;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) EditableViewController *editviewController;
@property (strong, nonatomic) NSMutableArray *heritagePlaces;
@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *desc;
@property (strong, nonatomic)NSData *imgdata;
@property (strong, nonatomic)NSURL *urlString;
@property (strong, nonatomic)NSData *screendata;
@property (strong, nonatomic)NSArray *arr;
- (IBAction)previewAction:(id)sender;

@end
