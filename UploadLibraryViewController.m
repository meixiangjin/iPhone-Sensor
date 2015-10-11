//
//  UploadLibraryViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "UploadLibraryViewController.h"
#import "RRSendMessageViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DLRadioButton.h"

@interface UploadLibraryViewController ()
@property (nonatomic, strong) UITextView *message;
@property (strong, nonatomic) IBOutlet UITextField *lat;
@property (strong, nonatomic) IBOutlet UITextField *lon;
@property (strong, nonatomic) IBOutlet UITextField *State;
@property (strong, nonatomic) IBOutlet UITextField *Zip;
@property (strong, nonatomic) IBOutlet UITextField *City;
@property (strong, nonatomic) IBOutlet UITextField *Street;
@property (strong, nonatomic) IBOutlet UITextField *loc;
@property (nonatomic) NSArray *buttomRadioButtons;
@property(nonatomic)NSArray * currentbuttomRadioButtons;
@end

@implementation UploadLibraryViewController
CLLocation * location1;
CLLocationManager *locationManager;
NSString * startAddressString;
NSString * returnAddress;
NSString * totalAddress;

- (void) newMessage {
    RRSendMessageViewController *controller = [[RRSendMessageViewController alloc] init];
    controller.uid=self.uid;
    controller.noiseLevel=self.noiseLevel;
    controller.sta=self.State.text;
    controller.city=self.City.text;
    controller.zip=self.Zip.text;
    controller.street=self.Street.text;
    controller.latitude=self.lat.text;
    controller.longitude=self.lon.text;


    NSString *buttonName = [(DLRadioButton *)self.buttomRadioButtons[0] selectedButton].titleLabel.text;
    
    NSString *currentstatebuttonName = [(DLRadioButton *)self.currentbuttomRadioButtons[0] selectedButton].titleLabel.text;
    
    NSLog(@"**********%@",self.loc.text);
    if(buttonName==nil){
        [[[UIAlertView alloc] initWithTitle:@"No Study Location Selected" message:buttonName delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else if(currentstatebuttonName==nil){
        [[[UIAlertView alloc] initWithTitle:@"No Current State Selected" message:@"Please select one state" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else if([self.loc.text isEqualToString:@""]){
        
        [[[UIAlertView alloc] initWithTitle:@"Please input location name" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    else{
        controller.libraryName=[NSString stringWithFormat:@"%@:%@",buttonName,self.loc.text];
        controller.currentstate=currentstatebuttonName;
        [controller presentController:self :^(RRMessageModel *model, BOOL isCancel) {
            
            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
 //  [ self.loc becomeFirstResponder];
    
    self.State.hidden=YES;
    self.City.hidden=YES;
    self.Street.hidden=YES;
    self.Zip.hidden=YES;
    self.lat.hidden=YES;
    self.lon.hidden=YES;
    
    
   

    
    
    
    
    
 
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager=[[CLLocationManager alloc]init];
        //  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        NSLog(@"works");
        
        
        locationManager.delegate=self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        
    }
    else{
        NSLog(@"not work");
    }
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    
    
    
    float longitude=location.coordinate.longitude;
    float latitude=location.coordinate.latitude;
//    self.lat.text= [NSString stringWithFormat:@"%f", latitude];
//    self.lon.text=[NSString stringWithFormat:@"%f", longitude];
    
    
    
    //float latitude=43.843811;
    //float longitude=-91.163857;
    
        self.lat.text= [NSString stringWithFormat:@"%f", latitude];
        self.lon.text=[NSString stringWithFormat:@"%f", longitude];

    
    
    //    float latitude=43.839619;
    //    float longitude=-91.197684;
    //    self.lat.text=@"43.839619";
    //    self.lon.text=@"-91.197684";
    //    location1=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    NSLog(@"dLongitude : %f", longitude);
    NSLog(@"dLatitude : %f", latitude);
    location1=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [self getownlocation];
    
    
    
//    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width+168,
//                                                                      self.view.frame.size.width, 50)];

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]
                                                                  initWithTitle:@"Add Photo" style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(newMessage)] ;
    //[sendButton setTitle:@"Add Photo" forState:UIControlStateNormal];
    //[sendButton addTarget:self action:@selector(newMessage) forControlEvents:UIControlEventTouchUpInside];
    //[sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[self.view addSubview:sendButton];
    
    //self.recordView = [[FXRecordArcView alloc] initWithFrame:CGRectMake(0, 280, 350, 100)];
    self.recordView = [[FXRecordArcView alloc] initWithFrame:CGRectMake(0, 350, 350, 100)];
    [self.view addSubview:self.recordView];
    self.recordView.delegate = self;
    
    DLRadioButton *firstRadioButton = [[DLRadioButton alloc] initWithFrame:CGRectMake(20, 100, 200, 25)];
    firstRadioButton.buttonSideLength = 20;
    [firstRadioButton setTitle:@"Library" forState:UIControlStateNormal];
    [firstRadioButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    firstRadioButton.circleColor = [UIColor blackColor];
    firstRadioButton.indicatorColor = [UIColor blackColor];
    firstRadioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // add other buttons
    [self.view addSubview:firstRadioButton];
    NSArray *buttonColors = @[[UIColor blackColor], [UIColor blackColor], [UIColor blackColor], [UIColor blackColor], [UIColor blackColor]];
    NSInteger i = 0;
    NSMutableArray *otherButtons = [NSMutableArray new];
    for (UIColor *buttonColor in buttonColors) {
        // customize this button
        DLRadioButton *radioButton = [[DLRadioButton alloc] initWithFrame:CGRectMake(20, 125+25*i, 200, 25)];
        radioButton.buttonSideLength = 20;
        [radioButton setTitleColor:buttonColor forState:UIControlStateNormal];
        //[radioButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        radioButton.circleColor = buttonColor;
        radioButton.indicatorColor = buttonColor;
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [otherButtons addObject:radioButton];
        [self.view addSubview:radioButton];
        i++;
    }
    firstRadioButton.otherButtons = otherButtons;
    [otherButtons[0]setTitle:@"Coffee shop" forState:UIControlStateNormal];
    [otherButtons[1]setTitle:@"Student lounge" forState:UIControlStateNormal];
    [otherButtons[2]setTitle:@"Study room" forState:UIControlStateNormal];
    [otherButtons[3]setTitle:@"Computer room" forState:UIControlStateNormal];
    [otherButtons[4]setTitle:@"Other" forState:UIControlStateNormal];
    self.buttomRadioButtons = [@[firstRadioButton] arrayByAddingObjectsFromArray:otherButtons];
    
    
    
    
    
    //current state radio button
    DLRadioButton *currentfirstRadioButton = [[DLRadioButton alloc] initWithFrame:CGRectMake(21, 332, 100, 25)];
    currentfirstRadioButton.buttonSideLength = 20;
    [currentfirstRadioButton setTitle:@"Unknown" forState:UIControlStateNormal];
    [currentfirstRadioButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    currentfirstRadioButton.circleColor = [UIColor blackColor];
    currentfirstRadioButton.indicatorColor = [UIColor blackColor];
    currentfirstRadioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // add other buttons
    [self.view addSubview:currentfirstRadioButton];
    NSArray *currentbuttonColors = @[[UIColor blackColor], [UIColor blackColor]];
    NSInteger j = 0;
    NSMutableArray *currentotherButtons = [NSMutableArray new];
    for (UIColor *buttonColor in currentbuttonColors) {
        // customize this button
        DLRadioButton *currentradioButton = [[DLRadioButton alloc] initWithFrame:CGRectMake(135+j*80, 332, 100, 25)];
        currentradioButton.buttonSideLength = 20;
        [currentradioButton setTitleColor:buttonColor forState:UIControlStateNormal];
        //[radioButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        currentradioButton.circleColor = buttonColor;
        currentradioButton.indicatorColor = buttonColor;
        currentradioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [currentotherButtons addObject:currentradioButton];
        [self.view addSubview:currentradioButton];
        j++;
    }
    currentfirstRadioButton.otherButtons = currentotherButtons;
    [currentotherButtons[0]setTitle:@"Full" forState:UIControlStateNormal];
    [currentotherButtons[1]setTitle:@"Not Full" forState:UIControlStateNormal];
    self.currentbuttomRadioButtons = [@[currentfirstRadioButton] arrayByAddingObjectsFromArray:currentotherButtons];
    
    //current state radio button

    
    
    
    
    
    
    
    
}
- (NSString *)fullPathAtCache:(NSString *)fileName{
    NSError *error;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (YES != [fm fileExistsAtPath:path]) {
        if (YES != [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"create dir path=%@, error=%@", path, error);
        }
    }
    return [path stringByAppendingPathComponent:fileName];
}
- (void)recordArcView:(FXRecordArcView *)arcView volume:(float)recordVolume{
    
    self.noiseLevel=recordVolume;
    if(recordVolume<=-50){
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Noise Level"
                                   message: [NSString stringWithFormat:@"Quiet"]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        
        [alert show];
    }
    
    if(recordVolume>-50 && recordVolume<=-40){
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Noise Level"
                                   message: [NSString stringWithFormat:@"A little loud"]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        
        [alert show];
    }
    if(recordVolume>-40 && recordVolume<=-20){
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Noise Level"
                                   message: [NSString stringWithFormat:@"Very loud"]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        
        [alert show];
    }
    //    if(recordVolume>-40 && recordVolume<=-30){
    //        UIAlertView *alert =
    //        [[UIAlertView alloc] initWithTitle: @"Noise Level"
    //                                   message: [NSString stringWithFormat:@"level 3 noise"]
    //                                  delegate: nil
    //                         cancelButtonTitle:@"OK"
    //                         otherButtonTitles:nil];
    //
    //        [alert show];
    //    }
    //    if(recordVolume>-30 && recordVolume<=-20){
    //        UIAlertView *alert =
    //        [[UIAlertView alloc] initWithTitle: @"Noise Level"
    //                                   message: [NSString stringWithFormat:@"level 4 noise"]
    //                                  delegate: nil
    //                         cancelButtonTitle:@"OK"
    //                         otherButtonTitles:nil];
    //
    //        [alert show];
    //    }
    if(recordVolume>-20 && recordVolume<=0){
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Noise Level"
                                   message: [NSString stringWithFormat:@"Incredibly loud"]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        
        [alert show];
    }
    
    
    
    
}
- (IBAction)tapRecordBtn:(id)sender {
    NSLog(@"the tap recordBtn");
    [self.recordView startForFilePath:[self fullPathAtCache:@"record.wav"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)getownlocation
{
    NSLog(@"Begin");
    __block NSString *returnAddress = @"";
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location1 completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
        }
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        startAddressString = [NSString stringWithFormat:@"%@ %@-%@-%@-%@-%@",
                              placemark.subThoroughfare, placemark.thoroughfare,
                              placemark.postalCode, placemark.locality,
                              placemark.administrativeArea,
                              placemark.country];
        returnAddress = startAddressString;
        
        
        [self remainderOfMethodHereUsingReturnAddress:returnAddress];
    }];
    
}

- (void)remainderOfMethodHereUsingReturnAddress:(NSString*)returnAddress {
    totalAddress=returnAddress;
    NSArray* foo = [totalAddress componentsSeparatedByString: @"-"];
    self.Street.text=[foo objectAtIndex: 0];
    self.Zip.text=[foo objectAtIndex:1];
    self.City.text=[foo objectAtIndex:2];
    self.State.text=[foo objectAtIndex:3];
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation=[locations lastObject];
    CLLocationCoordinate2D coor=currentLocation.coordinate;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)viewDidDisappear:(BOOL)animated{
    [locationManager stopUpdatingLocation];
}

-(IBAction)textFiledReturnEditing:(id)sender{
[sender resignFirstResponder];
}


@end

