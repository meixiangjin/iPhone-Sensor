//
//  ParkingViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "ParkingViewController.h"
#import "SearchParkingViewController.h"
@interface ParkingViewController ()
@property (strong,nonatomic) NSArray * cellNames;

@end

@implementation ParkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellNames = @[@"upload",@"map",@"table"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows=0;
    switch (section) {
        case 0:
            rows=1;
            break;
        case 1:
            rows=1;
            break;
        case 2:
            rows=1;
            break;
    }
    return rows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: [self.cellNames objectAtIndex: indexPath.section] forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text=@"Upload Information";
            cell.imageView.image=[UIImage imageNamed:@"Upload Filled-20-2"];
            break;
        case 1:
            cell.textLabel.text=@"View Map";
            cell.imageView.image=[UIImage imageNamed:@"Map Marker Filled-20"];
            break;
        case 2:
            cell.textLabel.text=@"Search Information";
            cell.imageView.image=[UIImage imageNamed:@"Search Filled-20"];
            break;
    }
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"IdeaDetailController prepareForSeque %@",segue.identifier);
    
    if ([segue.identifier isEqualToString: @"temperature"]) {
        TemperatureNavigationViewController * tnavigation=(TemperatureNavigationViewController *) segue.destinationViewController;
        TemperatureSensorTableViewController * tem =[tnavigation topViewController];
        tem.uid=self.uid;
        tem.hidesBottomBarWhenPushed = YES;
    }
    
    else if ([segue.identifier isEqualToString:@"maptoparking"]){
        ParkingMapTotalViewController * totalmap=(ParkingMapTotalViewController *)segue.destinationViewController;
        totalmap.hidesBottomBarWhenPushed = YES;
    }
    
    
    else if ([segue.identifier isEqualToString: @"table1"]) {
        SearchParkingViewController * searchparking=(SearchParkingViewController *)segue.destinationViewController ;
        searchparking.uid=self.uid;
        searchparking.hidesBottomBarWhenPushed = YES;
    }
    
    
}


-(void)viewWillAppear:(BOOL)animated {
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
