//
//  ReputationTableViewCell.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/23/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReputationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headIcon;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UILabel *custom;

@end
