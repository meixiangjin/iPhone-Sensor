//
//  LibraryMapViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 2/1/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "LibraryMapViewController.h"
static const CGFloat CalloutYOffset = 10.0f;
@interface LibraryMapViewController ()

@end

@implementation LibraryMapViewController

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
    
    // Do any additional setup after loading the view.
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
    self.TotalList=[[NSMutableArray alloc]init];
    self.oneTotalList=[[NSMutableArray alloc]init];
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)searchthisparking{
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/searchOneLibrary.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    NSString *body=[NSString stringWithFormat:@"latitude=%@&longitude=%@",self.lat,self.lon];
    NSLog(@"latitude:%@ longitude:%@",self.lat,self.lon);
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
    for (int i=0; i<receivedUrlArr1.count; i++) {
        NSDictionary *itemDic1=receivedUrlArr1[i];
        NSString * lla=itemDic1[@"latitude"];
        NSString * llo=itemDic1[@"longitude"];
        NSString * time=itemDic1[@"time"];
        NSString * username=itemDic1[@"username"];
        NSString * city=itemDic1[@"city"];
        NSString * street=itemDic1[@"street"];
        NSString * state=itemDic1[@"state"];
        NSString * zip=itemDic1[@"zip"];
        NSString * nvalue=itemDic1[@"noiselevel"];
        NSString * image=itemDic1[@"imagename"];
        NSString * note=itemDic1[@"note"];
        NSString * libraryname=itemDic1[@"libraryname"];
        
        NSString * ttt=[username stringByAppendingString:@"???"];
        ttt=[ttt stringByAppendingString:nvalue];
        ttt=[ttt stringByAppendingString:@"???"];
        ttt=[ttt stringByAppendingString:note];
        ttt=[ttt stringByAppendingString:@"???"];
        ttt=[ttt stringByAppendingString:image];
        ttt=[ttt stringByAppendingString:@"???"];
        ttt=[ttt stringByAppendingString:time];
        ttt=[ttt stringByAppendingString:@"???"];
        ttt=[ttt stringByAppendingString:libraryname];
        [self marking1:lla withlng1:llo withname:ttt];
        
        self.TotalList[i]=@{@"latitude":lla,@"longitude":llo,@"time":time,@"username":username,@"city":city,@"street":street,@"state":state,@"zip":zip,@"nvalue":nvalue,@"image":image,@"note":note,@"libraryname":libraryname};
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
    
    
    NSArray * titles=[marker.title componentsSeparatedByString:@"???"];
    NSString * correcttitle=titles[5];
//    self.calloutView.title = correcttitle;
//    self.calloutView.calloutOffset = CGPointMake(0, -CalloutYOffset);
//    
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
    NSString *body=[NSString stringWithFormat:@"latitude=%@&longitude=%@&type=Library",slla,slln];
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
            NSString * noiselevel=itemDic1[@"noiselevel"];
            NSString * image=itemDic1[@"imagename"];
            self.oneTotalList[i]=@{@"time":time,@"noiselevel":noiselevel,@"image":image};
        }
    }
    
    //compare time
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
    NSString * noiselevel=[self.oneTotalList objectAtIndex:indexPath.row][@"noiselevel"];
    NSArray * arrnoiselevel=[noiselevel componentsSeparatedByString:@")"];
    NSString * noiselevelcharacter=[NSString stringWithFormat:@"Noise Level:%@dB) ",arrnoiselevel[0]];
    
    ((ParkingMapTableViewCell *)cell).temperature.text=noiselevelcharacter;
    
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
    
    self.TotalList=[[NSMutableArray alloc]init];
    self.oneTotalList=[[NSMutableArray alloc]init];
    [self searchthisparking];
    float flatitude=[[self.TotalList[0] objectForKey:@"latitude"] floatValue];
    float flongitude=[[self.TotalList[0] objectForKey:@"longitude"] floatValue];
    CLLocationCoordinate2D here=CLLocationCoordinate2DMake(flatitude, flongitude);
    GMSCameraPosition * camera=[GMSCameraPosition cameraWithTarget:here zoom:25];
    self.mapView_.camera=camera;
    allmarkers=[[NSMutableArray alloc]init];

    
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

@end
