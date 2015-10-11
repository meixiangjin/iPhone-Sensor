//
//  UploadParkingViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "UploadParkingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TemperatureSensorTableViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TabBarViewController.h"
#import "RootViewController.h"
#import "ParkingViewController.h"
#import "LibraryViewController.h"
#import "DLRadioButton.h"
@interface UploadParkingViewController ()

@end

@implementation UploadParkingViewController
@synthesize uid;
CLLocationManager *locationManager;
NSString * startAddressString;
NSString * returnAddress;
NSString * totalAddress;

NSString *currentDate;


NSString *content;
NSString *content1;
NSString *content2;
float pickercount;
CLLocation * location1;



NSData *urlData5;
NSMutableArray *receivedUrlArr1;
NSMutableArray *ArrId1;
NSMutableArray *ArrLat1;
NSMutableArray *ArrLon1;
NSMutableArray *ArrTypename1;
float panduan;
NSString *typename;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.note.delegate=self;
    self.state.hidden=YES;
    self.city.hidden=YES;
    self.street.hidden=YES;
    self.zip.hidden=YES;
    self.lat.hidden=YES;
    self.lon.hidden=YES;
    self.temperature.text=self.tem;
    self.humidity.text=self.hum;
    pickercount=0;
    self.note.text=@" ";
    [[self.note layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.note layer] setBorderWidth:2];
    
    
    
    if ([self.panduan isEqualToString:@"YES"]) {
        UINavigationBar *myBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
        [self.view addSubview:myBar];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(Back)];
        self.navigationItem.leftBarButtonItem=leftButton;
        [myBar pushNavigationItem:self.navigationItem animated:YES];
        
    }
    
    
    NSLog(@"#################### %@",self.uid);

    if ([CLLocationManager locationServicesEnabled]) {
        locationManager=[[CLLocationManager alloc]init];
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
    //      float latitude=37.749043;
    //      float longitude=-122.420349;
//
//    float latitude=43.856022;
//    float longitude=-91.208817;
    self.lat.text= [NSString stringWithFormat:@"%f", latitude];
    self.lon.text=[NSString stringWithFormat:@"%f", longitude];
    
    NSLog(@"090909---------------- %@",self.lat.text);
    NSLog(@"090909---------------- %@",self.lon.text);
    location1=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [self getownlocation];
    [self searchnearbyparkingname:(NSString * )self.lat.text withlongitude:(NSString *)self.lon.text];
    
    //radio button
    DLRadioButton *firstRadioButton = [[DLRadioButton alloc] initWithFrame:CGRectMake(6, 360, 100, 25)];
    firstRadioButton.buttonSideLength = 20;
    [firstRadioButton setTitle:@"Unknown" forState:UIControlStateNormal];
    [firstRadioButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    firstRadioButton.circleColor = [UIColor blackColor];
    firstRadioButton.indicatorColor = [UIColor blackColor];
    firstRadioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // add other buttons
    [self.view addSubview:firstRadioButton];
    NSArray *buttonColors = @[[UIColor blackColor], [UIColor blackColor]];
    NSInteger i = 0;
    NSMutableArray *otherButtons = [NSMutableArray new];
    for (UIColor *buttonColor in buttonColors) {
        // customize this button
        DLRadioButton *radioButton = [[DLRadioButton alloc] initWithFrame:CGRectMake(120+i*80, 360, 100, 25)];
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
    [otherButtons[0]setTitle:@"Full" forState:UIControlStateNormal];
    [otherButtons[1]setTitle:@"Not Full" forState:UIControlStateNormal];
    self.buttomRadioButtons = [@[firstRadioButton] arrayByAddingObjectsFromArray:otherButtons];
    
    //radio button
    
    
    
    
    
    
    NSLog(@"the latitude is %@",self.lat.text);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"startAddressString is =============----------%@",startAddressString);
}
- (void)remainderOfMethodHereUsingReturnAddress:(NSString*)returnAddress {
    totalAddress=returnAddress;
    NSArray* foo = [totalAddress componentsSeparatedByString: @"-"];
    self.street.text=[foo objectAtIndex: 0];
    self.zip.text=[foo objectAtIndex:1];
    self.city.text=[foo objectAtIndex:2];
    self.state.text=[foo objectAtIndex:3];
    NSLog(@"000--------------------------- %@",self.city.text);
}




-(void)searchnearbyparkingname:(NSString* )latitude withlongitude:(NSString *)longitude{
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/GetParkingOneName.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    NSString *body=[NSString stringWithFormat:@"lat=%@&lon=%@",latitude,longitude];
    NSMutableURLRequest *request2=[NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request2 delegate:self];
    
    NSError *requestError2 = [[NSError alloc] init];
    NSHTTPURLResponse *response2 = nil;
    
    urlData5 = [NSURLConnection sendSynchronousRequest:request2
                                     returningResponse:&response2
                                                 error:&requestError2];
    NSLog(@"the urlData1 is %@",urlData5);
    
    
    receivedUrlArr1=[NSJSONSerialization JSONObjectWithData:urlData5 options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"the length is%lu",(unsigned long)receivedUrlArr1.count);
    NSLog(@"the number acount is %lu",(unsigned long)receivedUrlArr1.count);
    if (receivedUrlArr1.count==0) {
        [self searchnearbyparkingusegooglename:latitude withlongitude:longitude];
        
    }
    
    else{
        panduan=6;
        for (int i=0; i<receivedUrlArr1.count; i++) {
            NSDictionary *itemDic1=receivedUrlArr1[i];
            typename=itemDic1[@"parkingname"];
            self.parkingname.text=typename;
        }
        [self checkparkingname];
    }
}




-(void)searchnearbyparkingusegooglename:(NSString* )latitude withlongitude:(NSString *)longitude{
    NSString * input=@"parking";
    RequestForParking *rr=[[RequestForParking alloc] init];
    rr.selfslatitude=latitude;
    rr.selfslongitude=longitude;
    rr.type=input;
    
    NSDictionary *query = [NSDictionary alloc];
    SEL selector = @selector(addDirections1:);
    [rr setDirectionsQuery1:query
               withSelector:selector
               withDelegate:self];
}

- (void)addDirections1:(NSDictionary *)json {
    NSDictionary *results = [json objectForKey:@"results"];
    if (results.count==0) {
        panduan=3;
        [self checkparkingname];
    }
    else{
        panduan=6;
        for (int i=0; i<results.count; i++) {
            NSDictionary *onething=[json objectForKey:@"results"][i];
            typename=[onething objectForKey:@"name"];
            self.parkingname.text=typename;
        }
        [self checkparkingname];
    }
    
}

- (IBAction)takePicture:(id)sender {
    UIActionSheet * photoBtnActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library",@"Take Photo" ,nil];
    [photoBtnActionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [photoBtnActionSheet showInView:self.view.window];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        //Show Photo Library
        @try {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc] init];
                [imgPickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [imgPickerVC.navigationBar setBarStyle:UIBarStyleBlack];
                [imgPickerVC setDelegate:self];
                [imgPickerVC setAllowsEditing:NO];
                [self presentViewController:imgPickerVC animated:YES completion:nil];
            }else {
                
            }
        }
        @catch (NSException *exception) {
            
        }
    }
    if (buttonIndex == 1) {
        @try {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
                [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
                [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
                [cameraVC setDelegate:self];
                [cameraVC setAllowsEditing:NO];
                [self presentViewController:cameraVC animated:YES completion:nil];
                
            }else {
                NSLog(@"Camera is not available.");
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Camera is not available.");
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    pickercount++;
    NSLog(@"Image Picker Controller did finish picking media.");
    UIImage *imageview = info[UIImagePickerControllerOriginalImage];
    
    if (pickercount==1) {
        self.image1.image=imageview;
    }
    else if (pickercount==2){
        self.image2.image=imageview;
    }
    else if (pickercount==3){
        self.image3.image=imageview;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)upload:(id)sender {
    
    
    
    //    self.state.text=@"WI";
    //    self.city.text=@"La Crosse";
    //    self.zip.text=@"54601";
    //    self.street.text=@"2372 Sunset Ln";
    
    
    
    
    NSLog(@"the type name is 555555555555555555555555555555555  %@",typename);
    NSData * cc1;
    NSData * cc2;
    NSData * cc3;
    NSString * isimage=@"NO";
    //new 19
    NSLog(@"999999+++++{{{}}}}}}}}}} %@",self.parkingname.text);
    NSString *buttonName = [(DLRadioButton *)self.buttomRadioButtons[0] selectedButton].titleLabel.text;
    if (buttonName==nil) {
        [[[UIAlertView alloc] initWithTitle:@"No Current State Selected" message:@"Please select one state" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
    
    else if (self.parkingname.text==nil||[self.parkingname.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Can not be null!" message:@"please enter parkingname fields " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
    else{
        if (typename==nil) {
            NSString * result=[self checknameisequal:self.parkingname.text];
            if ([result isEqualToString:@"NO"]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Parkingname Can Not Same" message:@"please enter parkingname fields " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else{
                //new 20
                
                if (self.image1.image!=nil) {
                    isimage=@"YES";
                    cc1=UIImageJPEGRepresentation(self.image1.image, 1.0f);
                }
                if (self.image2.image!=nil) {
                    cc2=UIImageJPEGRepresentation(self.image2.image, 1.0f);
                    
                }
                if (self.image3.image!=nil) {
                    cc3=UIImageJPEGRepresentation(self.image3.image, 1.0f);
                }
                NSArray * arr=[[NSArray alloc]init];
                if (self.image1.image!=nil) {
                    if (self.image2.image!=nil) {
                        if (self.image3.image!=nil) {
                            arr=@[@{@"name":@"tt",@"image":cc1},@{@"name":@"ii",@"image":cc2},@{@"name":@"zz",@"image":cc3}];
                        }
                        else{
                            arr=@[@{@"name":@"tt",@"image":cc1},@{@"name":@"ii",@"image":cc2}];
                        }
                    }
                    else{
                        arr=@[@{@"name":@"tt",@"image":cc1}];
                    }
                }
                NSString *urlStr1=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/SAllSensor.php"];
                NSURL *url1=[NSURL URLWithString:urlStr1];
                NSMutableURLRequest *request1=[NSMutableURLRequest requestWithURL:url1];
                NSMutableData *postbody = [NSMutableData data];
                NSString * totalName=@"";
                NSString *boundary = @"---------------------------14737809831466499882746641449";
                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                
                if (arr.count>0) {
                    for (int i=0; i<[arr count]; i++) {
                        NSData *dataImage=[[arr objectAtIndex:i] valueForKey:@"image"];
                        // NSString *filename=[[arr objectAtIndex:i] valueForKey:@"name"];
                        if (dataImage) {
                            
                            NSUUID  *UUID = [NSUUID UUID];
                            NSString* imageName = [UUID UUIDString];
                            totalName=[NSString stringWithFormat:@"%@&%@", totalName,imageName];
                            int k=i+1;
                            [postbody appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                            [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image%d\"; filename=\"%@.png\"\r\n",k,imageName] dataUsingEncoding:NSUTF8StringEncoding]];
                            [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                            [postbody appendData:[NSData dataWithData:dataImage]];
                            [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                            
                            
                        }
                    }
                    
                }
                
                NSLog(@"total image is %@",totalName);
                
                NSString *postLength = [NSString stringWithFormat:@"%lu", arr.count+1];
                [request1 setValue:postLength forHTTPHeaderField:@"number"];
                NSString *postName = [NSString stringWithFormat:@"%@", totalName];
                [request1 setValue:postName forHTTPHeaderField:@"totalName"];
                [request1 addValue:contentType forHTTPHeaderField: @"Content-Type"];
                [request1 addValue:isimage forHTTPHeaderField: @"isimagehere"];
                [request1 setHTTPBody:postbody];
                
                NSDateFormatter *df=[[NSDateFormatter alloc]init];
                NSLocale *usLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                [df setLocale:usLocale];
                NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                [df setTimeZone:timeZone];
                df.dateFormat=@"yyyy-MM-dd HH:mm:ss";
                NSDate *date=[NSDate date];
                currentDate=[df stringFromDate:date];
                
                NSString *state=self.state.text;
                NSString *city=self.city.text;
                NSString *zip=self.zip.text;
                NSString *street=self.street.text;
                NSString *latitude=self.lat.text;
                NSString *longitude=self.lon.text;
                
                if (state==nil) {
                    state=@"NULL";
                }
                if (city==nil) {
                    city=@"NULL";
                }
                if (street==nil) {
                    street=@"NULL";
                }
                if (zip==nil) {
                    zip=@"NULL";
                }
                
                [request1 addValue:self.uid forHTTPHeaderField:@"userid"];
                [request1 addValue:@"Parking" forHTTPHeaderField:@"type"];
                [request1 addValue:currentDate forHTTPHeaderField:@"time"];
                [request1 addValue:latitude forHTTPHeaderField:@"latitude"];
                [request1 addValue:longitude forHTTPHeaderField:@"longitude"];
                [request1 addValue:city forHTTPHeaderField:@"city"];
                [request1 addValue:state forHTTPHeaderField:@"state"];
                [request1 addValue:zip forHTTPHeaderField:@"zip"];
                [request1 addValue:street forHTTPHeaderField:@"street"];
                [request1 addValue:self.parkingname.text forHTTPHeaderField:@"parkingname"];
                [request1 addValue:buttonName forHTTPHeaderField:@"currentstate"];
                
                //new 12
                NSString * temperaturetext=[self.temperature.text stringByReplacingOccurrencesOfString:@"°C"withString:@""];
                [request1 addValue:temperaturetext forHTTPHeaderField:@"temperature"];
                NSString * humiditytext=[self.humidity.text stringByReplacingOccurrencesOfString:@"%rH"withString:@""];
                [request1 addValue:humiditytext forHTTPHeaderField:@"humidity"];
                //new 12
                
                [request1 addValue:@"00" forHTTPHeaderField:@"grax"];
                [request1 addValue:@"00" forHTTPHeaderField:@"gray"];
                [request1 addValue:@"00" forHTTPHeaderField:@"graz"];
                
                [request1 addValue:@"00" forHTTPHeaderField:@"accx"];
                [request1 addValue:@"00" forHTTPHeaderField:@"accy"];
                [request1 addValue:@"00" forHTTPHeaderField:@"accz"];
                
                [request1 addValue:@"00" forHTTPHeaderField:@"rotx"];
                [request1 addValue:@"00" forHTTPHeaderField:@"roty"];
                [request1 addValue:@"00" forHTTPHeaderField:@"rotz"];
                [request1 addValue:@"0" forHTTPHeaderField:@"likecount"];
                [request1 addValue:@"NULL" forHTTPHeaderField:@"noiselevel"];
                [request1 addValue:self.note.text forHTTPHeaderField:@"note"];
                
                [request1 setHTTPMethod:@"POST"];
                NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request1 delegate:self];
                
                //////// mon 1:19
                UIStoryboard *str = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                TabBarViewController *main = [str instantiateViewControllerWithIdentifier:@"TabBar"];
                main.uid=self.uid;
                RootViewController *rr = (RootViewController *) [main.viewControllers objectAtIndex:0];
                ParkingViewController * pp= (ParkingViewController *)[[main. viewControllers objectAtIndex:1] topViewController ];
                LibraryViewController * ll= (LibraryViewController *)[[main.viewControllers objectAtIndex:2] topViewController];
                rr.uid=self.uid;
                pp.uid=self.uid;
                ll.uid=self.uid;
                [self presentViewController:main animated:YES completion:nil];
                
                //new 20
            }
        }
        //new 19
        else{
            
            if (self.image1.image!=nil) {
                isimage=@"YES";
                cc1=UIImageJPEGRepresentation(self.image1.image, 1.0f);
            }
            if (self.image2.image!=nil) {
                cc2=UIImageJPEGRepresentation(self.image2.image, 1.0f);
                
            }
            if (self.image3.image!=nil) {
                cc3=UIImageJPEGRepresentation(self.image3.image, 1.0f);
            }
            NSArray * arr=[[NSArray alloc]init];
            if (self.image1.image!=nil) {
                if (self.image2.image!=nil) {
                    if (self.image3.image!=nil) {
                        arr=@[@{@"name":@"tt",@"image":cc1},@{@"name":@"ii",@"image":cc2},@{@"name":@"zz",@"image":cc3}];
                    }
                    else{
                        arr=@[@{@"name":@"tt",@"image":cc1},@{@"name":@"ii",@"image":cc2}];
                    }
                }
                else{
                    arr=@[@{@"name":@"tt",@"image":cc1}];
                }
            }
            NSString *urlStr1=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/SAllSensor.php"];
            NSURL *url1=[NSURL URLWithString:urlStr1];
            NSMutableURLRequest *request1=[NSMutableURLRequest requestWithURL:url1];
            NSMutableData *postbody = [NSMutableData data];
            NSString * totalName=@"";
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            
            if (arr.count>0) {
                for (int i=0; i<[arr count]; i++) {
                    NSData *dataImage=[[arr objectAtIndex:i] valueForKey:@"image"];
                    // NSString *filename=[[arr objectAtIndex:i] valueForKey:@"name"];
                    if (dataImage) {
                        
                        NSUUID  *UUID = [NSUUID UUID];
                        NSString* imageName = [UUID UUIDString];
                        totalName=[NSString stringWithFormat:@"%@&%@", totalName,imageName];
                        int k=i+1;
                        [postbody appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image%d\"; filename=\"%@.png\"\r\n",k,imageName] dataUsingEncoding:NSUTF8StringEncoding]];
                        [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                        [postbody appendData:[NSData dataWithData:dataImage]];
                        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                        
                        
                    }
                }
                
            }
            
            NSLog(@"total image is %@",totalName);
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", arr.count+1];
            [request1 setValue:postLength forHTTPHeaderField:@"number"];
            NSString *postName = [NSString stringWithFormat:@"%@", totalName];
            [request1 setValue:postName forHTTPHeaderField:@"totalName"];
            [request1 addValue:contentType forHTTPHeaderField: @"Content-Type"];
            [request1 addValue:isimage forHTTPHeaderField: @"isimagehere"];
            [request1 setHTTPBody:postbody];
            
            NSDateFormatter *df=[[NSDateFormatter alloc]init];
            NSLocale *usLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [df setLocale:usLocale];
            NSTimeZone *timeZone = [NSTimeZone localTimeZone];
            [df setTimeZone:timeZone];
            df.dateFormat=@"yyyy-MM-dd HH:mm:ss";
            NSDate *date=[NSDate date];
            currentDate=[df stringFromDate:date];
            
            NSString *state=self.state.text;
            NSString *city=self.city.text;
            NSString *zip=self.zip.text;
            NSString *street=self.street.text;
            NSString *latitude=self.lat.text;
            NSString *longitude=self.lon.text;
            
            if (state==nil) {
                state=@"NULL";
            }
            if (city==nil) {
                city=@"NULL";
            }
            if (street==nil) {
                street=@"NULL";
            }
            if (zip==nil) {
                zip=@"NULL";
            }
            
            [request1 addValue:self.uid forHTTPHeaderField:@"userid"];
            [request1 addValue:@"Parking" forHTTPHeaderField:@"type"];
            [request1 addValue:currentDate forHTTPHeaderField:@"time"];
            [request1 addValue:latitude forHTTPHeaderField:@"latitude"];
            [request1 addValue:longitude forHTTPHeaderField:@"longitude"];
            [request1 addValue:city forHTTPHeaderField:@"city"];
            [request1 addValue:state forHTTPHeaderField:@"state"];
            [request1 addValue:zip forHTTPHeaderField:@"zip"];
            [request1 addValue:street forHTTPHeaderField:@"street"];
            [request1 addValue:self.parkingname.text forHTTPHeaderField:@"parkingname"];
            [request1 addValue:@"NULL" forHTTPHeaderField:@"libraryname"];
            [request1 addValue:buttonName forHTTPHeaderField:@"currentstate"];
            
            //new 12
            NSString * temperaturetext=[self.temperature.text stringByReplacingOccurrencesOfString:@"°C"withString:@""];
            [request1 addValue:temperaturetext forHTTPHeaderField:@"temperature"];
            NSString * humiditytext=[self.humidity.text stringByReplacingOccurrencesOfString:@"%rH"withString:@""];
            [request1 addValue:humiditytext forHTTPHeaderField:@"humidity"];
            //new 12
            
            [request1 addValue:@"00" forHTTPHeaderField:@"grax"];
            [request1 addValue:@"00" forHTTPHeaderField:@"gray"];
            [request1 addValue:@"00" forHTTPHeaderField:@"graz"];
            
            [request1 addValue:@"00" forHTTPHeaderField:@"accx"];
            [request1 addValue:@"00" forHTTPHeaderField:@"accy"];
            [request1 addValue:@"00" forHTTPHeaderField:@"accz"];
            
            [request1 addValue:@"00" forHTTPHeaderField:@"rotx"];
            [request1 addValue:@"00" forHTTPHeaderField:@"roty"];
            [request1 addValue:@"00" forHTTPHeaderField:@"rotz"];
            [request1 addValue:@"0" forHTTPHeaderField:@"likecount"];
            [request1 addValue:@"NULL" forHTTPHeaderField:@"noiselevel"];
            [request1 addValue:self.note.text forHTTPHeaderField:@"note"];
            
            [request1 setHTTPMethod:@"POST"];
            NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request1 delegate:self];
            
            
            //////
            UIStoryboard *str = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TabBarViewController *main = [str instantiateViewControllerWithIdentifier:@"TabBar"];
            main.uid=self.uid;
            RootViewController *rr = (RootViewController *) [main.viewControllers objectAtIndex:0];
            ParkingViewController * pp= (ParkingViewController *)[[main. viewControllers objectAtIndex:1] topViewController ];
            LibraryViewController * ll= (LibraryViewController *)[[main.viewControllers objectAtIndex:2] topViewController];
            rr.uid=self.uid;
            pp.uid=self.uid;
            ll.uid=self.uid;
            [self presentViewController:main animated:YES completion:nil];
            
        }
    }
    NSLog(@"11111111111111111111111111111111   is image %@",isimage);
    //the new sun 10:49
    if ([self.note.text containsString:@"full"])
    {
        NSDictionary * userInfo = [NSDictionary dictionaryWithObject: [NSDate date] forKey: @"CurrentDate"];
        
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center postNotificationName: self.parkingname.text
                              object: nil
                            userInfo: userInfo];
        
    }
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation=[locations lastObject];
    CLLocationCoordinate2D coor=currentLocation.coordinate;
}

-(NSString *)checknameisequal:(NSString *)name{
    NSString *urlStr=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/searchparkingnames.php"];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSString *body=[NSString stringWithFormat:@"parkingname=%@",name];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    NSError *requestError = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData * urlData = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&requestError];
    // NSLog(@"the urlData1 is %@",urlData5);
    NSMutableArray *receivedUrlArr = [[NSMutableArray alloc]init];
    receivedUrlArr=[[NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:nil] mutableCopy];
    NSString * result=@"YES";
    if (receivedUrlArr.count>0) {
        for (int i=0; i<receivedUrlArr.count; i++) {
            NSDictionary *itemDic=receivedUrlArr[i];
            NSString * parkingname=itemDic[@"parkingname"];
            if ([parkingname isEqualToString:name]) {
                result=@"NO";
            }
        }
    }
    
    return result;
}


-(void)Back{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewDidDisappear:(BOOL)animated{
    [locationManager stopUpdatingLocation];
}

-(void)checkparkingname{
    if (typename!=nil) {
        self.parkingname.userInteractionEnabled=NO;
    }
}

-(IBAction)textFiledReturnEditing:(id)sender{
    [sender resignFirstResponder];
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
