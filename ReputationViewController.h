//
//  ReputationViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/23/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReputationTableViewCell.h"
#import "MessageViewController.h"
@interface ReputationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray * reputationList;
@property (strong,nonatomic) NSString * uid;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
