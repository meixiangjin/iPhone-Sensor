//
//  SearchTableViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/25/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHPickView.h"
#import "SearchParkingViewController.h"
#import "NMRangeSlider.h"
@interface SearchTableViewController : UIViewController
@property(strong,nonatomic)NSString * uid;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *zipCode;
@property(strong,nonatomic)NSString * address;
@property(strong,nonatomic)NSString * time;
@property(strong,nonatomic)NSString * likecount;
@property(strong,nonatomic)NSString * ageforregister;
@property(strong,nonatomic)NSString * temperaturemin;
@property(strong,nonatomic)NSString * temperaturemax;
@property(strong,nonatomic)NSString * humiditymin;
@property (strong, nonatomic) IBOutlet NMRangeSlider *labelSlider;
@property (strong, nonatomic) IBOutlet NMRangeSlider *labelSlider1;
@property(strong,nonatomic)NSString * humiditymax;
@property (strong, nonatomic) IBOutlet UILabel *lowerLabel;
@property (strong, nonatomic) IBOutlet UILabel *upperLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowerLabel1;
@property (strong, nonatomic) IBOutlet UILabel *upperLabel1;

-(IBAction)labelSliderChanged:(NMRangeSlider *)sender;
-(IBAction)labelSlider1Changed:(NMRangeSlider *)sender;
@end
