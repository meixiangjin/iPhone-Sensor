//
//  PersonalMainPageTableViewCell.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/19/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"
@interface PersonalMainPageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headIcon;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *note;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *character;
@property (strong,nonatomic) ClickImage * image1;
@property (strong,nonatomic) ClickImage * image2;
@property (strong,nonatomic) ClickImage * image3;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *count;
@property(strong,nonatomic)NSString * rid;
@property (strong,nonatomic)  NSString * uid;
@end
