//
//  ParkingMapViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 2/1/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "ParkingMapViewController.h"
static const CGFloat CalloutYOffset = 10.0f;
@interface ParkingMapViewController ()

@end

@implementation ParkingMapViewController
NSData *urlData5;
NSMutableArray *receivedUrlArr1;
NSMutableArray *allmarkers;
UITableView *firstTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    firstTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 400, 320, 120)];
    firstTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    firstTableView.delegate = self;
    firstTableView.dataSource = self;
    firstTableView.hidden=YES;
    [self.view addSubview:firstTableView];
//    self.calloutView = [[SMCalloutView alloc] init];
//    self.calloutView.hidden = YES;
    self.emptyCalloutView = [[UIView alloc] initWithFrame:CGRectZero];
    self.navigationItem.title=@"Home Page";
    UINavigationBar *myBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:myBar];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem=leftButton;
    [myBar pushNavigationItem:self.navigationItem animated:YES];
}
-(void)Back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    self.mapView_.delegate = self;
    self.mapView_.mapType=kGMSTypeNormal;
    self.TotalList=[[NSMutableArray alloc]initWithCapacity:5];
    self.oneTotalList=[[NSMutableArray alloc]initWithCapacity:5];
    [self searchthisparking];
    float flatitude=[[self.TotalList[0] objectForKey:@"latitude"] floatValue];
    float flongitude=[[self.TotalList[0] objectForKey:@"longitude"] floatValue];
    CLLocationCoordinate2D here=CLLocationCoordinate2DMake(flatitude, flongitude);
    GMSCameraPosition * camera=[GMSCameraPosition cameraWithTarget:here zoom:25];
    self.mapView_.camera=camera;
    allmarkers=[[NSMutableArray alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)searchthisparking{
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/getnearbyparkingsbyname.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    NSString *body=[NSString stringWithFormat:@"parkingname=%@",self.name];
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
    
    if (receivedUrlArr1.count>0) {
        for (int i=0; i<receivedUrlArr1.count; i++) {
            NSDictionary *itemDic1=receivedUrlArr1[i];
            NSString * lla=itemDic1[@"latitude"];
            NSString * llo=itemDic1[@"longitude"];
            NSString * time=itemDic1[@"time"];
            NSString * userid=itemDic1[@"userid"];
            NSString * city=itemDic1[@"city"];
            NSString * street=itemDic1[@"street"];
            NSString * state=itemDic1[@"state"];
            NSString * zip=itemDic1[@"zip"];
            NSString * tvalue=itemDic1[@"temv"];
            NSString * hvalue=itemDic1[@"humv"];
            NSString * image=itemDic1[@"imagename"];
            NSString * note=itemDic1[@"note"];
            
            NSString * ttt=[self.name stringByAppendingString:@"???"];
            ttt=[ttt stringByAppendingString:tvalue];
            ttt=[ttt stringByAppendingString:@"???"];
            ttt=[ttt stringByAppendingString:hvalue];
            ttt=[ttt stringByAppendingString:@"???"];
            ttt=[ttt stringByAppendingString:note];
            ttt=[ttt stringByAppendingString:@"???"];
            ttt=[ttt stringByAppendingString:image];
            ttt=[ttt stringByAppendingString:@"???"];
            ttt=[ttt stringByAppendingString:time];
            
            [self marking1:lla withlng1:llo withname:ttt];
            
            self.TotalList[i]=@{@"latitude":lla,@"longitude":llo,@"time":time,@"userid":userid,@"city":city,@"street":street,@"state":state,@"zip":zip,@"tvalue":tvalue,@"hvalue":hvalue,@"image":image,@"note":note};
        }
    }
    else{
        self.TotalList[0]=@{@"latitude":self.lat,@"longitude":self.lon};
        NSString * ttt=[self.name stringByAppendingString:@"???"];
        ttt=[ttt stringByAppendingString:@"NULL"];
        ttt=[ttt stringByAppendingString:@"???"];
        ttt=[ttt stringByAppendingString:@"NULL"];
        ttt=[ttt stringByAppendingString:@"???"];
        ttt=[ttt stringByAppendingString:@"NULL"];
        ttt=[ttt stringByAppendingString:@"???"];
        ttt=[ttt stringByAppendingString:@"NO"];
        ttt=[ttt stringByAppendingString:@"???"];
        ttt=[ttt stringByAppendingString:@"NULL"];
        [self marking1:self.lat withlng1:self.lon withname:ttt];
    }
    
}


- (void)marking1:(NSString *)sl withlng1:(NSString *)sln withname:(NSString *)name{
    float latitude = [sl floatValue];
    float longitude=[sln floatValue];
    CLLocationCoordinate2D place = CLLocationCoordinate2DMake(latitude,longitude);
    GMSMarker *placemarker = [[GMSMarker alloc] init];
    placemarker.icon=[GMSMarker markerImageWithColor:[UIColor greenColor]];
    placemarker.position=place;
    placemarker.map=self.mapView_;
    placemarker.title=name;
}
-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    
    firstTableView.hidden=NO;
    CLLocationCoordinate2D anchor = marker.position;
    CGPoint point = [mapView.projection pointForCoordinate:anchor];
//    self.calloutView.title = self.name;
//    self.calloutView.calloutOffset = CGPointMake(0, -CalloutYOffset);
//    self.calloutView.hidden = NO;
//    int judge=0;
//    
//    for (int i=0; i<self.TotalList.count; i++) {
//        if ([self.TotalList[i][@"name"] isEqualToString:marker.title]) {
//            judge=1;
//        }
//    }
//    if (judge==1) {
//        self.calloutView.rightAccessoryView.hidden=YES;
//        judge=0;
//    }
    CGRect calloutRect = CGRectZero;
    calloutRect.origin = point;
    calloutRect.size = CGSizeZero;
    
    firstTableView.center=CGPointMake(self.view.frame.size.width/2, point.y+60);
    firstTableView.layer.cornerRadius=8.0f;
    
    
    
    float lla=marker.position.latitude;
    float lln=marker.position.longitude;
    
    NSString *slla= [NSString stringWithFormat:@"%f", lla];
    NSString *slln = [NSString stringWithFormat:@"%f", lln];
    NSString *urlStrOne=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/getsamelocation.php"];
    NSURL *urlOne=[NSURL URLWithString:urlStrOne];
    NSString *body=[NSString stringWithFormat:@"latitude=%@&longitude=%@&type=Parking",slla,slln];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:urlOne];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnectionOne=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    NSError *requestError = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    
    NSData * urlDataOne = [NSURLConnection sendSynchronousRequest:request
                                                returningResponse:&response
                                                            error:&requestError];
    
    NSArray * receivedUrlArr=[NSJSONSerialization JSONObjectWithData:urlDataOne options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"the length is%lu",(unsigned long)receivedUrlArr.count);
    NSLog(@"the number acount is %lu",(unsigned long)receivedUrlArr.count);
    
    if (receivedUrlArr.count>0) {
        for (int i=0; i<receivedUrlArr.count; i++) {
            NSDictionary *itemDic1=receivedUrlArr[i];
            NSString * time=itemDic1[@"time"];
            NSString * tvalue=itemDic1[@"temv"];
            NSString * hvalue=itemDic1[@"humv"];
            NSString * image=itemDic1[@"imagename"];
            self.oneTotalList[i]=@{@"time":time,@"tvalue":tvalue,@"hvalue":hvalue,@"image":image};
        }
    }
    self.oneTotalList =(NSMutableArray *) [self.oneTotalList  sortedArrayUsingComparator: ^NSComparisonResult(id a, id b)
                                           {
                                               
                                               
                                               NSString * r1=[a objectForKey:@"time"];
                                               NSString * r2=[b objectForKey:@"time"];
                                               NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
                                               [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                               NSDate *date1= [formatter dateFromString:r1];
                                               NSDate *date2 = [formatter dateFromString:r2];
                                               NSComparisonResult  result = [date1 compare:date2];
                                               if (result == NSOrderedDescending) {
                                                   return (NSComparisonResult)NSOrderedAscending;
                                               } else if ( result == NSOrderedAscending) {
                                                   return (NSComparisonResult)NSOrderedDescending;
                                               } else {
                                                   return (NSComparisonResult)NSOrderedSame;
                                               }
                                           }];
    
    [firstTableView reloadData];
    return self.emptyCalloutView;
    
    
    
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


- (void)nn:(id)sender {
    NSLog(@"ttttttt");
}


//tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.oneTotalList.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* CellIdentifier =[NSString stringWithFormat:@"%@%ld", @"ParkingMapTableViewCell",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[[NSBundle mainBundle] loadNibNamed:@"ParkingMapTableViewCell" owner:self options:nil] lastObject];
    cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    ((ParkingMapTableViewCell *)cell).time.text=[self.oneTotalList objectAtIndex:indexPath.row][@"time"];
    NSString * temperature=[self.oneTotalList objectAtIndex:indexPath.row][@"tvalue"];
    NSString * humidity=[self.oneTotalList objectAtIndex:indexPath.row][@"hvalue"];
    NSString * temperaturecharacter=[NSString stringWithFormat:@"%@%@°C , Humidity:%@%%rH",@"Temperature:",temperature,humidity];
    
    ((ParkingMapTableViewCell *)cell).temperature.text=temperaturecharacter;
    
    CGSize size=CGSizeMake(43, 43);//set the width and height
    NSString * totalstring=[self.oneTotalList objectAtIndex:indexPath.row][@"image"];
    if ([totalstring isEqualToString:@"NO"]) {
        
    }
    
    else{
        NSArray * names=[[self.oneTotalList objectAtIndex:indexPath.row][@"image"] componentsSeparatedByString:@"&"];
        
        NSString *imageURL1=[NSString stringWithFormat:@"%@%@%@",@"http://euryale.cs.uwlax.edu/uploads/",names[1],@".png"];
        
        NSData *imageData1= [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL1]];
        UIImage * imageView1=[UIImage imageWithData:imageData1];
        UIImage * resizedImage1= [self resizeImage:imageView1 imageSize:size];
        ((ParkingMapTableViewCell *)cell).image1.image=resizedImage1;
        
        if (names.count>2 && names.count<4) {
            
            NSString *imageURL2=[NSString stringWithFormat:@"%@%@%@",@"http://euryale.cs.uwlax.edu/uploads/",names[2],@".png"];
            NSData *imageData2= [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL2]];
            UIImage * imageView2=[UIImage imageWithData:imageData2];
            UIImage * resizedImage2= [self resizeImage:imageView2 imageSize:size];
            ((ParkingMapTableViewCell *)cell).image2.image=resizedImage2;
        }
        
        if (names.count>3) {
            NSString *imageURL2=[NSString stringWithFormat:@"%@%@%@",@"http://euryale.cs.uwlax.edu/uploads/",names[2],@".png"];
            
            NSData *imageData2= [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL2]];
            UIImage * imageView2=[UIImage imageWithData:imageData2];
            UIImage * resizedImage2= [self resizeImage:imageView2 imageSize:size];
            ((ParkingMapTableViewCell *)cell).image2.image=resizedImage2;
            
            
            NSString *imageURL3=[NSString stringWithFormat:@"%@%@%@",@"http://euryale.cs.uwlax.edu/uploads/",names[3],@".png"];
            
            NSData *imageData3= [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL3]];
            UIImage * imageView3=[UIImage imageWithData:imageData3];
            UIImage * resizedImage3= [self resizeImage:imageView3 imageSize:size];
            ((ParkingMapTableViewCell *)cell).image3.image=resizedImage3;
        }
    }
    return cell;
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    firstTableView.hidden=YES;
//    self.calloutView.hidden = YES;
    //ading new
    self.TotalList=[[NSMutableArray alloc]initWithCapacity:5];
    self.oneTotalList=[[NSMutableArray alloc]initWithCapacity:5];
    [self searchthisparking];
    float flatitude=[[self.TotalList[0] objectForKey:@"latitude"] floatValue];
    float flongitude=[[self.TotalList[0] objectForKey:@"longitude"] floatValue];
    CLLocationCoordinate2D here=CLLocationCoordinate2DMake(flatitude, flongitude);
    GMSCameraPosition * camera=[GMSCameraPosition cameraWithTarget:here zoom:25];
    self.mapView_.camera=camera;
    allmarkers=[[NSMutableArray alloc]init];

    //ading new
    
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    NSLog(@"fds");
    NSLog(@"fff %f",marker.position.latitude);
    [mapView setSelectedMarker:marker];
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 117;
    return height;
}

//tableview

@end