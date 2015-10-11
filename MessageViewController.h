//
//  MessageViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/23/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)UIImage * headIcon;
@property(strong,nonatomic)NSString * username;
@property(strong,nonatomic)NSString * note;
@property(strong,nonatomic)NSString * type;
@property(strong,nonatomic)NSString * character;
@property(strong,nonatomic)UIImage * image1;
@property(strong,nonatomic)UIImage * image2;
@property(strong,nonatomic)UIImage * image3;
@property(strong,nonatomic)NSString * address;
@property(strong,nonatomic)NSString * time;

@end
