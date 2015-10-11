//
//  HomeViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/18/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrostedViewController.h"
#import "PersonalMainPageTableViewCell.h"
#import "NearbyPersonViewController.h"
@interface HomeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
-(IBAction)showMenu:(id)sender;
@property(strong,nonatomic)NSString * uid;
@property(strong,nonatomic)UIRefreshControl * refresh;
@end
