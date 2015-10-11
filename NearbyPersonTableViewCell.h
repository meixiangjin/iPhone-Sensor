//
//  NearbyPersonTableViewCell.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/19/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyPersonTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UIImageView *headIcon;

@end
