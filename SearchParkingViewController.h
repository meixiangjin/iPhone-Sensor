//
//  SearchParkingViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/26/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTableViewController.h"
#import "PersonalMainPageTableViewCell.h"

@interface SearchParkingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSString * likemin;
@property(strong,nonatomic)NSString * likemax;
@property(strong,nonatomic)NSString * tmin;
@property(strong,nonatomic)NSString * tmax;
@property(strong,nonatomic)NSString * hmin;
@property(strong,nonatomic)NSString * hmax;
@property(strong,nonatomic)NSString *city;
@property(strong,nonatomic)NSString *state;
@property(strong,nonatomic)NSString *zip;
@property(strong,nonatomic)NSString * time;
@property(strong,nonatomic)NSString * fcount;
@property(strong,nonatomic)NSMutableArray * uploads;
@property(strong,nonatomic)NSString * uid;
@property(strong,nonatomic)NSString * username;
@property(strong,nonatomic)NSString * parkingname;
@property(strong,nonatomic)NSString * ageforregister;
@end
