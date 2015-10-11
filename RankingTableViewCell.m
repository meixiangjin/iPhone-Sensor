//
//  RankingTableViewCell.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "RankingTableViewCell.h"

@implementation RankingTableViewCell

- (void)awakeFromNib {
    // Initialization code

    self.label2.textColor=[UIColor grayColor];
    self.label3.textColor=[UIColor grayColor];
    self.username.textColor=[UIColor orangeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
