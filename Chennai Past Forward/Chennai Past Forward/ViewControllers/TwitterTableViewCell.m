//
//  TwitterTableViewCell.m
//  TheMusic Academy
//
//  Created by BTS on 13/08/15.
//  Copyright (c) 2015 BTS. All rights reserved.
//

#import "TwitterTableViewCell.h"

@implementation TwitterTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self createViews];
    }
    
    return self;
}


- (void)createViews
{
    self.headingLabel = [[UILabel alloc] init];
    self.headingLabel.textColor = [UIColor blackColor];
    self.headingLabel.text = @"";
    self.headingLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    [self addSubview:self.headingLabel];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.textColor=[UIColor colorWithRed:38.82/256.0 green:83.83/256.0 blue:119.97/256.0 alpha:1.0];
     self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    self.descriptionLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openUrl:)];
    gestureRec.numberOfTouchesRequired = 1;
    gestureRec.numberOfTapsRequired = 1;
    [self.descriptionLabel addGestureRecognizer:gestureRec];

    self.descriptionLabel.text = @"";
    
    [self addSubview:self.descriptionLabel];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor=[UIColor blackColor];
    self.contentLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    self.contentLabel.text = @"";
    self.contentLabel.numberOfLines = 3;
    [self addSubview:self.contentLabel];
    
    self.dateLabel =[[UILabel alloc] init];
    self.dateLabel.textColor=[UIColor blackColor];
    self.dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    self.dateLabel.text =@"";
    [self addSubview:self.dateLabel];
    
    self.twImage =[[UIImageView alloc] init];
    [self addSubview:self.twImage];
    
}

- (void)openUrl:(id)sender
{
    UIGestureRecognizer *rec = (UIGestureRecognizer *)sender;
    
    id hitLabel = [self hitTest:[rec locationInView:self] withEvent:UIEventTypeTouches];
    
    if ([hitLabel isKindOfClass:[UILabel class]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:((UILabel *)hitLabel).text]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.headingLabel.frame = CGRectMake(68, 5, 150,20);
    self.descriptionLabel.frame = CGRectMake(68, 60, 200, 20);
    self.contentLabel.frame = CGRectMake(68, 19, 200, 50);
    self.dateLabel.frame = CGRectMake(240, 2, 120, 15);
    self.twImage.frame = CGRectMake(10,15,50,45);

}


@end
