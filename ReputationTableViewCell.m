//
//  ReputationTableViewCell.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/23/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "ReputationTableViewCell.h"

@implementation ReputationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.custom.textColor=[UIColor orangeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
