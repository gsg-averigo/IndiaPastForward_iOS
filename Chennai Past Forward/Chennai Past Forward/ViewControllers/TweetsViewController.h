//
//  TweetsViewController.h
//  Chennai Past Forward
//
//  Created by BTS on 01/09/15.
//  Copyright (c) 2015 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController, TabsViewController;
@interface TweetsViewController : UITableViewController
{
    UIRefreshControl *refreshControl;
    
}
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) TabsViewController *tabsViewController;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) NSMutableArray *statusArray;
@end
