//
//  FilterActionSheetListViewController.h
//  Chennai Past Forward
//
//  Created by BTS on 18/07/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionSheetDelegate;

@interface FilterActionSheetListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) id<ActionSheetDelegate> delegate;
@property(strong,nonatomic) IBOutlet UITableView *table_list;
@property(strong,nonatomic) IBOutlet UIButton *search;
@property(strong,nonatomic) NSArray *list_values;
@property (strong, nonatomic) NSArray *buttonTitles;
- (id)initWithButtonTitles:(NSArray *)buttonTitles;
@end

@protocol ActionSheetDelegate <NSObject>
- (void)actionSheet:(FilterActionSheetListViewController *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
