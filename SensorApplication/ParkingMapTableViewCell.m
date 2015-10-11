//
//  ParkingMapTableViewCell.m
//  SensorApplication
//
//  Created by Meixiang Jin on 3/15/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "ParkingMapTableViewCell.h"

@implementation ParkingMapTableViewCell

- (void)awakeFromNib {
    self.time.font=[UIFont systemFontOfSize:13];
    self.time.textColor=[UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
