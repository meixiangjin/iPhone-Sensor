//
//  ParkingViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemperatureSensorTableViewController.h"
#import "TemperatureNavigationViewController.h"
#import "ParkingMapTotalViewController.h"
@interface ParkingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSString * uid;

@end
