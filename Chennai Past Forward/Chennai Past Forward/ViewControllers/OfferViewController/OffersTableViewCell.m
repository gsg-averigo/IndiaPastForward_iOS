//
//  OffersTableViewCell.m
//  Chennai Past Forward
//
//  Created by BTS on 25/11/15.
//  Copyright (c) 2015 Harish. All rights reserved.
//

#import "OffersTableViewCell.h"

@implementation OffersTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
+ (NSString *)reuseIdentifier {
    return @"CustomCellIdentifier";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
