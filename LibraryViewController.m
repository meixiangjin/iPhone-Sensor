//
//  LibraryViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "LibraryViewController.h"
#import "UploadLibraryViewController.h"
#import "LibraryMapTotalViewController.h"
@interface LibraryViewController ()
@property (strong,nonatomic) NSArray * cellNames;
@end

@implementation LibraryViewController

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
            cell.imageView.image=[UIImage imageNamed:@"Upload Filled-20"];
            break;
        case 1:
            cell.textLabel.text=@"View Map";
            cell.imageView.image=[UIImage imageNamed:@"Map Marker Filled-20-2"];
            break;
        case 2:
            cell.textLabel.text=@"Search Information";
             cell.imageView.image=[UIImage imageNamed:@"Search Filled-20-2"];
            break;
    }
    return cell;
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString: @"uploadLibrary"]) {
        UploadLibraryViewController * upController = (UploadLibraryViewController *) segue.destinationViewController;
        upController.uid=self.uid;
        upController.hidesBottomBarWhenPushed = YES;
    }
    
    else if ([segue.identifier isEqualToString: @"ll"]) {
        LibraryMapTotalViewController * maptotal=(LibraryMapTotalViewController *)segue.destinationViewController;
        maptotal.hidesBottomBarWhenPushed = YES;
    }
    else if ([segue.identifier isEqualToString: @"tableLibrary"]) {
        TableLibraryViewController * table=(TableLibraryViewController *)segue.destinationViewController;
        table.uid=self.uid;
        table.hidesBottomBarWhenPushed = YES;
        
    }
}


@end
