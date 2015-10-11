//
//  OwnReputationViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/23/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnReputationTableViewCell.h"
#import "MessageViewController.h"


@interface OwnReputationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray * reputationList;
@property (strong,nonatomic) NSString * uid;

@end
