//
//  OwnViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalMainPageTableViewCell.h"
@interface OwnViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSString * uid;
@property (strong,nonatomic) NSMutableArray * ownList;
@end
