//
//  SearchLibraryViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/28/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "ZHPickView.h"
#import "NMRangeSlider.h"
@interface SearchLibraryViewController : UIViewController
@property(strong,nonatomic)NSString * uid;
@property(strong,nonatomic)NSString * address;
@property(strong,nonatomic)NSString * time;
@property(strong,nonatomic)NSString * likecount;
@property(strong,nonatomic)NSString * noisemin;
@property(strong,nonatomic)NSString * noisemax;
@property(strong,nonatomic)NSString * ageforregister;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *nmin;
@property (strong, nonatomic) IBOutlet UIView *rangeSelector;
@property (strong, nonatomic) IBOutlet UILabel *nmax;
@property (strong, nonatomic) IBOutlet NMRangeSlider *labelSlider2;
@property (strong, nonatomic) IBOutlet UILabel *lowerLabel;
@property (strong, nonatomic) IBOutlet UILabel *upperLabel;
-(IBAction)labelSliderChanged:(NMRangeSlider *)sender;
@end