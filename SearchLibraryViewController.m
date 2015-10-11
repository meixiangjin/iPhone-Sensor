//
//  SearchLibraryViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/28/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "SearchLibraryViewController.h"
#import "TableLibraryViewController.h"

@interface SearchLibraryViewController ()<ZHPickViewDelegate>
@property(nonatomic,strong)ZHPickView *pickview;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property (strong, nonatomic) IBOutlet UITextField *zipCode;
@property(nonatomic,strong)NSArray *cellNames;
@end

@implementation SearchLibraryViewController
@synthesize labelSlider2;
@synthesize lowerLabel;
@synthesize upperLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.address=@"State,City";
    self.time=@"MM/DD/YYYY";
    self.likecount=@"xx-xx";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self hideExcessLine:self.tableView];
    self.cellNames = @[@"time",@"likecount",@"address",@"ageforregister"];
    self.nmin.text=@"-80";
    self.nmax.text=@"0";
    [self configureLabelSlider];
    
}
- (void)viewDidUnload
{
    [self setLowerLabel:nil];
    [self setUpperLabel:nil];
    [self setLabelSlider2:nil];
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateSliderLabels];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
    //self.noisemin=self.nmin.text;
    //self.noisemax=self.nmax.text;
    // self.noisemin=@"-80";
    NSLog(@"the time is %@",self.time);
    NSLog(@"the likecount is %@",self.likecount);
    NSLog(@"the address is %@",self.address);
    NSLog(@"the nmin is %@",self.noisemin);
    NSLog(@"the nmax is %@",self.noisemax);
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
        NSLog(@"sssss000++++++++++++++++ %@",zip);
    }
    
    if (![self.address isEqualToString:@"State,City"]) {
        NSArray * array=[self.address componentsSeparatedByString:@","];
        state=[array objectAtIndex:0];
        city=[array objectAtIndex:1];
        //zip=[array objectAtIndex:2];
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
    
    
    TableLibraryViewController *Lctrl = [self.navigationController viewControllers][1];
    
    [Lctrl setLikemin:likemin];
    [Lctrl setLikemax:likemax];
    [Lctrl setNmin:self.noisemin];
    [Lctrl setNmax:self.noisemax];
    [Lctrl setCity:city];
    [Lctrl setState:state];
    [Lctrl setZip:zip];
    [Lctrl setTime:time];
    [Lctrl setAgeforregister:age];
    
    NSLog(@"lctrl time is %@  %@ %@ %@ %@ %@ %@ %@" ,time,likemax,likemin,self.noisemax,self.noisemin,city,state,zip );
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)textFiledReturnEditing:(id)sender{
    [sender resignFirstResponder];
    
}
//
- (void) configureLabelSlider
{
    self.labelSlider2.minimumValue = -80;
    self.labelSlider2.maximumValue = 0;
    
    self.labelSlider2.lowerValue = -80;
    self.labelSlider2.upperValue = 0;
    
    self.labelSlider2.minimumRange = 10;
}

- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    self.lowerLabel.text = [NSString stringWithFormat:@"%d dB", (int)self.labelSlider2.lowerValue];
    
    self.upperLabel.text = [NSString stringWithFormat:@"%d dB", (int)self.labelSlider2.upperValue];
    
    NSArray * afirst=[self.lowerLabel.text componentsSeparatedByString:@"dB"];
    NSString * first=afirst[0];
    self.noisemin=first;
    
    NSArray * bfirst=[self.upperLabel.text componentsSeparatedByString:@"dB"];
    NSString * birst=bfirst[0];
    self.noisemax=birst;
    
    
    
}
-(IBAction)labelSliderChanged:(NMRangeSlider *)sender{
    [self updateSliderLabels];
}

@end
