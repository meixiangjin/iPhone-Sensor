//
//  MessageViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/23/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "MessageViewController.h"
#import "PersonalMainPageTableViewCell.h"
@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //self.navigationItem.title=@"OneReputation";
    
    UINavigationBar *myBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:myBar];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem=leftButton;
    [myBar pushNavigationItem:self.navigationItem animated:YES];
    // Do any additional setup after loading the view from its nib.
}
-(void)Back{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
   
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* CellIdentifier =[NSString stringWithFormat:@"%@%ld", @"PersonalMainPageTableViewCell",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalMainPageTableViewCell" owner:self options:nil] lastObject];
    cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    ((PersonalMainPageTableViewCell *)cell).likeButton.hidden=YES;
    ((PersonalMainPageTableViewCell *)cell).count.hidden=YES;
    ((PersonalMainPageTableViewCell *)cell).username.text=self.username;
    ((PersonalMainPageTableViewCell *)cell).note.text=self.note;
    ((PersonalMainPageTableViewCell *)cell).time.text=self.time;
     ((PersonalMainPageTableViewCell *)cell).type.text=self.type;
    ((PersonalMainPageTableViewCell *)cell).address.text=self.address;
    ((PersonalMainPageTableViewCell *)cell).character.text=self.character;
    ((PersonalMainPageTableViewCell *)cell).headIcon.image=self.headIcon;
    ((PersonalMainPageTableViewCell *)cell).image1.image=self.image1;
    ((PersonalMainPageTableViewCell *)cell).image2.image=self.image2;
    ((PersonalMainPageTableViewCell *)cell).image3.image=self.image3;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 290;
    return height;
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
