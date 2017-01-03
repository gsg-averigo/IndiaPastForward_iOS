//
//  NearByTableViewCell.h
//  Chennai Past Forward
//
//  Created by BTS on 02/02/16.
//  Copyright © 2016 Harish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *adressLbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet UIImageView *buildingImage;

@end
