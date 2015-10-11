//
//  NearbyPersonViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/19/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyPersonTableViewCell.h"
#import "PersonalViewController.h"
@interface NearbyPersonViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray * peopleList;

@end
