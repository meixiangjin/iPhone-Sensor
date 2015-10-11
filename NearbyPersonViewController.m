//
//  NearbyPersonViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/19/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "NearbyPersonViewController.h"
#import "HomeViewController.h"
@interface NearbyPersonViewController ()

@end

@implementation NearbyPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView reloadData];
    self.navigationItem.title=@"People Nearby";
    
//    UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self.navigationController.viewControllers[0] action:@selector(Back:)];
//    self.navigationItem.leftBarButtonItem=_backButton;
    UINavigationBar *myBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:myBar];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem=leftButton;
    [myBar pushNavigationItem:self.navigationItem animated:YES];
    
    
    
    
}
-(void)Back{
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_peopleList count];
    // return 5;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* CellIdentifier =[NSString stringWithFormat:@"%@%ld", @"NearbyPersonTableViewCell",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil != cell){
        return cell;
    }
    cell = [[[NSBundle mainBundle] loadNibNamed:@"NearbyPersonTableViewCell" owner:self options:nil] lastObject];
    cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSLog(@"table cell %@",CellIdentifier);
    ((NearbyPersonTableViewCell *)cell).username.text=[_peopleList objectAtIndex:indexPath.row][@"username"];
    ((NearbyPersonTableViewCell *)cell).distance.text=[_peopleList objectAtIndex:indexPath.row][@"distance"];
    
    
    CGSize size=CGSizeMake(36, 36);//set the width and height
    UIImage * resizedImage= [self resizeImage:[_peopleList objectAtIndex:indexPath.row][@"portrait"] imageSize:size];
    ((NearbyPersonTableViewCell *)cell).headIcon.image=resizedImage;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    PersonalViewController * personal=[[PersonalViewController alloc]initWithNibName:@"PersonalViewController" bundle:nil];
    NSString * uid=[self.peopleList objectAtIndex:indexPath.row][@"userid"];
    personal.uid=uid;
    personal.navigationItem.title=@"Nearby Person";
    [self presentViewController:personal animated:YES completion:nil];
    //[self.navigationController pushViewController: personal animated: YES];
  
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 60;
    return height;
}
-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    return newImage;
    
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.peopleList==nil) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Try Again" message:@"Name and Password doesn't match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    
    }

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
