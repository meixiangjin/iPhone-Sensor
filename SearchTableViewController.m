//
//  SearchTableViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/25/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "SearchTableViewController.h"

@interface SearchTableViewController ()<ZHPickViewDelegate>
@property(nonatomic,strong)ZHPickView *pickview;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)NSArray *cellNames;
@end

@implementation SearchTableViewController
@synthesize labelSlider;
@synthesize lowerLabel;
@synthesize upperLabel;

@synthesize labelSlider1;
@synthesize lowerLabel1;
@synthesize upperLabel1;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.address=@"State,City";
    self.time=@"MM/DD/YYYY";
    self.likecount=@"xx-xx";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    [self hideExcessLine:self.tableView];
    self.cellNames = @[@"time",@"likecount",@"address",@"ageforregister"];
    [self configureLabelSlider];
    // Do any additional setup after loading the view.
}





- (void)viewDidUnload
{
    
    [self setLowerLabel:nil];
    [self setUpperLabel:nil];
    [self setLabelSlider:nil];
    
    [self setLabelSlider1:nil];
    [self setLowerLabel1:nil];
    [self setUpperLabel1:nil];
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateSliderLabels];
    
}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)hideExcessLine:(UITableView *)tableView{
    
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[self.cellNames objectAtIndex: indexPath.row]];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"Posted Since";
            cell.detailTextLabel.text=@"MM/DD/YYYY";
            break;
        case 1:
            cell.textLabel.text=@"Like Count";
            cell.detailTextLabel.text=@"xx-xx";
            break;
        case 2:
            cell.textLabel.text=@"Location";
            cell.detailTextLabel.text=@"State,City";
            break;
        case 3:
            cell.textLabel.text=@"User Age";
            cell.detailTextLabel.text=@"At least X years";
            break;
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _indexPath=indexPath;
    [_pickview remove];
    UITableViewCell * cell=[self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"Posted Since"]) {
        NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
        _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    }
    else{
        _pickview=[[ZHPickView alloc] initPickviewWithPlistName:cell.textLabel.text isHaveNavControler:NO];
    }
    _pickview.delegate=self;
    
    [_pickview show];
    
}



#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    UITableViewCell * cell=[self.tableView cellForRowAtIndexPath:_indexPath];
    cell.detailTextLabel.text=resultString;
    
    if (_indexPath.row==0) {
        self.time=resultString;
    }
    else if (_indexPath.row==1){
        self.likecount=resultString;
    }
    else if (_indexPath.row==2){
        self.address=resultString;
    }
    else{
        self.ageforregister=resultString;
    }
    
}

- (IBAction)Done:(id)sender {
    
    NSString * city=@"anything";
    NSString * state=@"anything";
    NSString * zip=@"anything";
    NSString * likemin=@"0";
    NSString * likemax=@"10000000";
    NSString * time=@"0000-00-00";
    NSString * username=@"anything";
    NSString * parkingname=@"anything";
    NSString * age=@"0";
    
    if (![self.zipCode.text isEqualToString:@""]) {
        zip=self.zipCode.text;
    }
    
    if (![self.address isEqualToString:@"State,City"]) {
        NSArray * array=[self.address componentsSeparatedByString:@","];
        state=[array objectAtIndex:0];
        city=[array objectAtIndex:1];
    }
    
    if (![self.likecount isEqualToString:@"xx-xx"]) {
        NSArray * likearray=[self.likecount componentsSeparatedByString:@"-"];
        if (likearray.count==2) {
            likemin=[likearray objectAtIndex:0];
            likemax=[likearray objectAtIndex:1];
        }
        else{
            NSArray * likearray1=[self.likecount componentsSeparatedByString:@"+"];
            likemin=[likearray1 objectAtIndex:0];
        }
    }
    if (![self.time isEqualToString:@"MM/DD/YYYY"]) {
        time=self.time;
    }
    
    if (![self.ageforregister isEqualToString:@"x YEAR More"]) {
        NSArray * agearray1=[self.ageforregister componentsSeparatedByString:@" "];
        age=[agearray1 objectAtIndex:2];
    }
    SearchParkingViewController * parkingview=[self.navigationController viewControllers][1];
    [parkingview setLikemin:likemin];
    [parkingview setLikemax:likemax];
    [parkingview setHmin:self.humiditymin];
    [parkingview setHmax:self.humiditymax];
    [parkingview setTime:time];
    [parkingview setTmin:self.temperaturemin];
    [parkingview setTmax:self.temperaturemax];
    [parkingview setCity:city];
    [parkingview setState:state];
    [parkingview setZip:zip];
    [parkingview setUsername:username];
    [parkingview setParkingname:parkingname];
    [parkingview setAgeforregister:age];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)textFiledReturnEditing:(id)sender{
    [sender resignFirstResponder];
}



#pragma mark -
#pragma mark - Label  Slider

- (void) configureLabelSlider
{
    self.labelSlider.minimumValue = -40;
    self.labelSlider.maximumValue = 50;
    
    self.labelSlider.lowerValue = -40;
    self.labelSlider.upperValue = 50;
    
    self.labelSlider.minimumRange = 10;
    
    
    self.labelSlider1.minimumValue=0;
    self.labelSlider1.maximumValue=100;
    
    self.labelSlider1.lowerValue=0;
    self.labelSlider1.upperValue=100;
    
    self.labelSlider1.minimumRange = 10;
    
    
}

- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x);
    lowerCenter.y = (self.labelSlider.center.y - 30.0f);
    self.lowerLabel.text = [NSString stringWithFormat:@"%d °C", (int)self.labelSlider.lowerValue];
    CGPoint upperCenter;
    upperCenter.x = (self.labelSlider.upperCenter.x + self.labelSlider.frame.origin.x);
    upperCenter.y = (self.labelSlider.center.y - 30.0f);
    self.upperLabel.text = [NSString stringWithFormat:@"%d °C", (int)self.labelSlider.upperValue];
    CGPoint lowerCenter1;
    lowerCenter1.x = (self.labelSlider1.lowerCenter.x + self.labelSlider1.frame.origin.x);
    lowerCenter1.y = (self.labelSlider1.center.y - 30.0f);
    self.lowerLabel1.text = [NSString stringWithFormat:@"%d %%rH", (int)self.labelSlider1.lowerValue];
    
    CGPoint upperCenter1;
    upperCenter1.x = (self.labelSlider1.upperCenter.x + self.labelSlider1.frame.origin.x);
    upperCenter1.y = (self.labelSlider1.center.y - 30.0f);
    
    self.upperLabel1.text = [NSString stringWithFormat:@"%d %%rH", (int)self.labelSlider1.upperValue];
    NSArray * afirst=[ self.lowerLabel.text componentsSeparatedByString:@"°C"];
    NSArray * asecond=[self.upperLabel.text  componentsSeparatedByString:@"°C"];
    NSString * first=afirst[0];
    NSString * second=asecond[0];
    
    self.temperaturemin=first;
    self.temperaturemax=second;
    
    
    NSArray * bfirst=[ self.lowerLabel1.text componentsSeparatedByString:@"%rH"];
    NSArray * bsecond=[self.upperLabel1.text  componentsSeparatedByString:@"%rH"];
    NSString * first1=bfirst[0];
    NSString * second1=bsecond[0];
    
    self.humiditymin=first1;
    self.humiditymax=second1;
}

-(IBAction)labelSliderChanged:(NMRangeSlider *)sender{
    [self updateSliderLabels];
}

-(IBAction)labelSlider1Changed:(NMRangeSlider *)sender{
    [self updateSliderLabels];
}
@end

