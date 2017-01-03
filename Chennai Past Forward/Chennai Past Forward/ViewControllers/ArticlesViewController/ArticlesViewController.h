//
//  ArticlesViewController.h
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController, TabsViewController;
@interface ArticlesViewController : UITableViewController
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) TabsViewController *tabsViewController;
@property (strong, nonatomic) NSMutableArray *articles;
@property (strong) NSMutableArray *article_device;
@end