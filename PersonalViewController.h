//
//  PersonalViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/22/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalMainPageTableViewCell.h"
@interface PersonalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray * personalList;
@property (strong,nonatomic)NSString * uid;
@end
