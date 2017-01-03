//
//  OffersTableViewCell.h
//  Chennai Past Forward
//
//  Created by BTS on 25/11/15.
//  Copyright (c) 2015 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffersTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *offerImages;

@property (strong, nonatomic) IBOutlet UILabel *descLabel;

@end
