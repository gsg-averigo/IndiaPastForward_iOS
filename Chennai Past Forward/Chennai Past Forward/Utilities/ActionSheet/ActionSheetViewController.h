//
//  ActionSheetViewController.h
//  cpf
//
//  Created by Harish Kishenchand on 18/10/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionSheetDelegate;

@interface ActionSheetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) id<ActionSheetDelegate> delegate;
@property (strong, nonatomic) NSArray *buttonTitles;
- (id)initWithButtonTitles:(NSArray *)buttonTitles;
@end


@protocol ActionSheetDelegate <NSObject>
- (void)actionSheet:(ActionSheetViewController *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@end