//
//  ParkingMapTableViewCell.h
//  SensorApplication
//
//  Created by Meixiang Jin on 3/15/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkingMapTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *temperature;


@end
