//
//  OffersViewController.h
//  Chennai Past Forward
//
//  Created by Harish Kishenchand on 23/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController, TabsViewController;
@interface OffersViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) TabsViewController *tabsViewController;
@property (strong, nonatomic) NSMutableArray *offers;
@property (strong, nonatomic) NSMutableArray *arrCount;
@property (strong, nonatomic) NSMutableArray *addition;
@property (strong, nonatomic) NSMutableArray *heritagePlaces;
@end
