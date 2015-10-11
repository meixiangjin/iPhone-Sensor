//
//  ParkingMapTotalViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 2/1/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "ParkingMapTotalViewController.h"
#import "DLRadioButton.h"
static const CGFloat CalloutYOffset = 10.0f;
@interface ParkingMapTotalViewController (){
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
    CLLocationManager *locationManager;
    float latitudes;
    float longitudes;
    GMSPolyline *polylinetotal;
    NSData *urlData5;
    NSMutableArray *receivedUrlArr1;
    NSData *urlData6;
    NSMutableArray *receivedUrlArr6;
    NSMutableArray *resultUrlArray;
    NSMutableArray *ArrId1;
    NSMutableArray *ArrTime1;
    NSMutableArray *ArrLat1;
    NSMutableArray *ArrLon1;
    NSMutableArray *ArrCity1;
    NSMutableArray *ArrState1;
    NSMutableArray *ArrZip1;
    NSMutableArray *ArrStreet1;
    NSMutableArray *ArrUserid1;
    NSCountedSet *countedSet;
    NSMutableArray *finalArray;
    NSMutableArray * googleparkingnames;
    int pi;
    NSString * input;
    
    NSString * parkingname111;
    NSString * dateclickcar;
    NSDate * currentdatetime;
    NSTimer *timer;
}

@end

@implementation ParkingMapTotalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    resultUrlArray=[[NSMutableArray alloc]init];
    
    self.TotalList=[[NSMutableArray alloc]init];
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    self.mapView_.myLocationEnabled=YES;
    self.mapView_.settings.myLocationButton = YES;
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
    
    longitudes=location.coordinate.longitude;
    latitudes=location.coordinate.latitude;
    
    
    
    //new
//    longitudes=-122.415710;
//    latitudes=37.721455;
    //new
    
    NSLog(@"the llll is %f",longitudes);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitudes longitude:longitudes zoom:14];
    self.mapView_.camera=camera;
    self.mapView_.delegate = self;
    self.mapView_.mapType=kGMSTypeNormal;
    
    self.calloutView = [[SMCalloutView alloc] init];
    self.calloutView.hidden = YES;
    UIImageView *carView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Driving.png"]];
    UIButton *blueView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    blueView.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
    [blueView addTarget:self action:@selector(carClicked) forControlEvents:UIControlEventTouchUpInside];
    carView.frame = CGRectMake(11, 14, carView.image.size.width, carView.image.size.height);
    [blueView addSubview:carView];
    self.calloutView.leftAccessoryView = blueView;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self
               action:@selector(calloutAccessoryButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    self.calloutView.rightAccessoryView = button;
    
    self.emptyCalloutView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getmapfromgoogle];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)carClicked{
    
    
    GMSMarker * mm=self.mapView_.selectedMarker;
    
    CLLocationCoordinate2D position=CLLocationCoordinate2DMake(mm.position.latitude, mm.position.longitude);
    
    [self mapViewDirection:self.mapView_ didTapAtCoordinate:position];
    
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    NSLocale *usLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [df setLocale:usLocale];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [df setTimeZone:timeZone];
    df.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    NSDate *date=[NSDate date];
    currentdatetime=date;
    dateclickcar=[df stringFromDate:date];
    parkingname111=mm.title;
    UIBackgroundTaskIdentifier bgTask;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self
                                           selector:@selector(startcheck) userInfo:nil repeats:YES];
    
}


-(void)startcheck{
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    NSLocale *usLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [df setLocale:usLocale];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [df setTimeZone:timeZone];
    df.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    NSDate *date=[NSDate date];
    NSTimeInterval secondsBetween = [date timeIntervalSinceDate:currentdatetime];
    int timeperiod=round(secondsBetween/60);
    if (timeperiod>60) {
        [timer invalidate];
        timer=nil;
    }
    
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/FindFullParking.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    
    NSString *body=[NSString stringWithFormat:@"parkingname=%@&time=%@",parkingname111,dateclickcar];
    NSMutableURLRequest *request2=[NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request2 delegate:self];
    NSError *requestError2 = [[NSError alloc] init];
    NSHTTPURLResponse *response2 = nil;
    urlData6 = [NSURLConnection sendSynchronousRequest:request2
                                     returningResponse:&response2
                                                 error:&requestError2];
    if (urlData6!=nil) {
        receivedUrlArr6 = [[NSMutableArray alloc]init];
        receivedUrlArr6=[[NSJSONSerialization JSONObjectWithData:urlData6 options:NSJSONReadingAllowFragments error:nil] mutableCopy];
    }
    if (receivedUrlArr6.count>0) {
        for (int i=0; i<receivedUrlArr6.count; i++) {
            NSDictionary *itemDic1=receivedUrlArr6[i];
            NSString * time=itemDic1[@"time"];
            NSString * note=itemDic1[@"note"];
            NSString * currentstate=itemDic1[@"currentstate"];
            if([currentstate isEqualToString:@"Full"]){
                dateclickcar=time;
                [self alert];
            }
        }
    }
    
    
    
    
    
}

-(void)alert{
    NSDate * alarmTime=[[NSDate date]dateByAddingTimeInterval:2.0];
    UIApplication * app=[UIApplication sharedApplication];
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification) {
        
        notification.fireDate=alarmTime;
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody=@"There is no vacant space in this parking spot!";
        notification.repeatInterval=0;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
}
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    CLLocationCoordinate2D anchor = marker.position;
    
    CGPoint point = [mapView.projection pointForCoordinate:anchor];
    self.calloutView.rightAccessoryView.hidden=NO;
    NSString * tempstring=@"";
    NSArray * temparray=[marker.title componentsSeparatedByString:@" "];
    if (temparray.count>3) {
        self.calloutView.title=[NSString stringWithFormat:@"%@ %@ %@",temparray[0],temparray[1],temparray[2]];
        for (int i=3;  i<temparray.count;i++) {
            tempstring=[NSString stringWithFormat:@"%@ %@",tempstring,temparray[i]];
        }
        self.calloutView.subtitle=tempstring;
    }
    else{
        self.calloutView.title = marker.title;
        self.calloutView.subtitle=tempstring;
    }
    self.calloutView.calloutOffset = CGPointMake(0, -CalloutYOffset);
    
    self.calloutView.hidden = NO;
    int judge=0;
    
    for (int i=0; i<self.TotalList.count; i++) {
        if ([self.TotalList[i][@"name"] isEqualToString:marker.title]) {
            judge=1;
        }
    }
    
    for (int i=0; i<self.SameList.count; i++) {
        if ([self.SameList[i][@"name"] isEqualToString:marker.title]) {
            judge=1;
        }
    }
    
    if (judge==1) {
        self.calloutView.rightAccessoryView.hidden=YES;
        judge=0;
    }
    CGRect calloutRect = CGRectZero;
    calloutRect.origin = point;
    calloutRect.size = CGSizeZero;
    
    [self.calloutView presentCalloutFromRect:calloutRect
                                      inView:mapView
                           constrainedToView:mapView
                                    animated:YES];
    
    return self.emptyCalloutView;
}


- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    self.calloutView.hidden = YES;
    if (pi==1) {
        polylinetotal.map=nil;
        pi=0;
    }
    
}
- (void)calloutAccessoryButtonTapped:(id)sender {
    
    if (self.mapView_.selectedMarker) {
        
        UIStoryboard *str = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ParkingMapViewController *parkingmap = [str instantiateViewControllerWithIdentifier:@"parkingmap"];
        parkingmap.name=self.mapView_.selectedMarker.title;
        float ll1=self.mapView_.selectedMarker.position.latitude;
        float ll2=self.mapView_.selectedMarker.position.longitude;
        NSString * sll1=[NSString stringWithFormat:@"%f",ll1];
        NSString * sll2=[NSString stringWithFormat:@"%f",ll2];
        parkingmap.lat=sll1;
        parkingmap.lon=sll2;
        [self presentViewController: parkingmap animated: YES completion: nil];
        
    }
    
    
}
-(void)getmapfromgoogle{
    //fake latitude and longitude
//    longitudes=-122.415710;
//    latitudes=37.721455;
    //fake latitude and longitude
    NSString * sla=[NSString stringWithFormat:@"%f", latitudes];
    NSString * slo=[NSString stringWithFormat:@"%f", longitudes];
    
    input=@"parking";
    RequestForParking *rr=[[RequestForParking alloc] init];
    rr.selfslatitude=sla;
    rr.selfslongitude=slo;
    rr.type=input;
    
    NSDictionary *query = [NSDictionary alloc];
    SEL selector = @selector(addDirections1:);
    [rr setDirectionsQuery:query
              withSelector:selector
              withDelegate:self];
    
    
    
    
}
- (void)addDirections1:(NSDictionary *)json {
    
    NSDictionary *results = [json objectForKey:@"results"];
    for (int i=0; i<results.count; i++) {
        NSDictionary *onething=[json objectForKey:@"results"][i];
        NSDictionary * geometry=[onething objectForKey:@"geometry"];
        NSString * name=[onething objectForKey:@"name"];
        NSDictionary * location=[geometry objectForKey:@"location"];
        NSString * lat=[location objectForKey:@"lat"];
        NSString * lng=[location objectForKey:@"lng"];
        self.TotalList[i]=@{@"latitude":lat,@"longitude":lng,@"name":name};
    }
    NSLog(@"0909090 the count is %d",self.TotalList.count);
    [self getmapfromdatabase];
}
-(void)getmapfromdatabase{
//    longitudes=-122.415710;
//    latitudes=37.721455;
    NSString * sla=[NSString stringWithFormat:@"%f", latitudes];
    NSString * slo=[NSString stringWithFormat:@"%f", longitudes];
    
    NSLog(@"sla is %@, slo is %@",sla,slo);
    
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/ParkingGoogle.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    NSString *body=[NSString stringWithFormat:@"lat=%@&lon=%@&type=Parking",sla,slo];
    NSMutableURLRequest *request2=[NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request2 delegate:self];
    NSError *requestError2 = [[NSError alloc] init];
    NSHTTPURLResponse *response2 = nil;
    urlData5 = [NSURLConnection sendSynchronousRequest:request2
                                     returningResponse:&response2
                                                 error:&requestError2];
    if (urlData5!=nil) {
        receivedUrlArr1 = [[NSMutableArray alloc]init];
        receivedUrlArr1=[[NSJSONSerialization JSONObjectWithData:urlData5 options:NSJSONReadingAllowFragments error:nil] mutableCopy];
    }
    
    
    
    
    if (receivedUrlArr1.count>0) {
        for (int i=0; i<receivedUrlArr1.count; i++) {
            NSDictionary *itemDic1=receivedUrlArr1[i];
            NSString * parkingname=itemDic1[@"parkingname"];
            
            NSString * time=itemDic1[@"time"];
            for (int j=i+1; j<receivedUrlArr1.count; j++) {
                NSDictionary *itemDic2=receivedUrlArr1[j];
                NSString * parkingname1=itemDic2[@"parkingname"];
                NSString * time1=itemDic2[@"time"];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSDate *date= [formatter dateFromString:time];
                NSDate *date1 = [formatter dateFromString:time1];
                
                NSComparisonResult result = [date compare:date1];
                
                if ([parkingname isEqualToString:parkingname1]) {
                    
                    if (result == NSOrderedDescending) {
                        [receivedUrlArr1 removeObjectAtIndex:j];
                    }
                    else{
                        [receivedUrlArr1 removeObjectAtIndex:i];
                    }
                    
                }
                
            }
            
        }
        for (int i=0; i<receivedUrlArr1.count; i++) {
            NSDictionary *itemDic1=receivedUrlArr1[i];
            NSString * parkingname=itemDic1[@"parkingname"];
           
            NSString * time=itemDic1[@"time"];
            for (int j=i+1; j<receivedUrlArr1.count; j++) {
                NSDictionary *itemDic2=receivedUrlArr1[j];
                NSString * parkingname1=itemDic2[@"parkingname"];
                NSString * time1=itemDic2[@"time"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSDate *date= [formatter dateFromString:time];
                NSDate *date1 = [formatter dateFromString:time1];
                
                NSComparisonResult result = [date compare:date1];
                if ([parkingname isEqualToString:parkingname1]) {
                    NSLog(@"the same parking name is %@",parkingname);
                    if (result == NSOrderedDescending) {
                        [receivedUrlArr1 removeObjectAtIndex:j];
                    }
                    else{
                        [receivedUrlArr1 removeObjectAtIndex:i];
                    }
                }
            }
            
        }
        
        
        
        if (self.TotalList.count>0) {
            for (int i=0; i<receivedUrlArr1.count; i++) {
                NSDictionary *itemDic1=receivedUrlArr1[i];
                NSString * parkingname=itemDic1[@"parkingname"];
                  NSLog(@"the last1 parkingname is %@",parkingname);
                NSString * time=itemDic1[@"time"];
                NSDateFormatter *df=[[NSDateFormatter alloc]init];
                NSLocale *usLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                [df setLocale:usLocale];
                NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                [df setTimeZone:timeZone];
                df.dateFormat=@"yyyy-MM-dd HH:mm:ss";
                NSDate * currentdate=[NSDate date];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate * datefromdatabase=[formatter dateFromString:time];
                
                for (int j=0; j<self.TotalList.count; j++) {
                   
                    if ([parkingname isEqualToString:[self.TotalList objectAtIndex:j][@"name"]]) {
                        NSLog(@"the  parkingname is %@",parkingname);
                        NSTimeInterval secondsBetween = [currentdate timeIntervalSinceDate:datefromdatabase];
                        int timeperiod=round(secondsBetween/60);
                        
                        NSLog(@"the nstimeinterval is %@,%@,%f",currentdate,datefromdatabase,timeperiod);
                        
                        if (timeperiod>120) {
                            NSLog(@"the blue pin is %@",[self.TotalList objectAtIndex:j][@"name"]);
                            [self marking2:[self.TotalList objectAtIndex:j][@"latitude"] withlng:[self.TotalList objectAtIndex:j][@"longitude"] withname:[self.TotalList objectAtIndex:j][@"name"]];
                        }
                        else{
                             NSLog(@"the blue flag is %@",[self.TotalList objectAtIndex:j][@"name"]);
                            [self marking3:[self.TotalList objectAtIndex:j][@"latitude"] withlng:[self.TotalList objectAtIndex:j][@"longitude"] withname:[self.TotalList objectAtIndex:j][@"name"]];
                        }
                        
                        
                        [self.SameList addObject:[receivedUrlArr1 objectAtIndex:i]];
                        [self.TotalList removeObjectAtIndex:j];
                        [receivedUrlArr1 removeObjectAtIndex:i];
                        j--;
                        i--;
                    }
                    
                    
                    
                }
                
            }
        }
        
        
    }
    

    
    if (receivedUrlArr1.count>0) {
        for (int i=0; i<receivedUrlArr1.count; i++) {
            NSDictionary *itemDic1=receivedUrlArr1[i];
            NSString * lat=itemDic1[@"latitude"];
            NSString * lon=itemDic1[@"longitude"];
            NSString * parkingname=itemDic1[@"parkingname"];
            
            
            NSLog(@"the lat is %@, the lon is %@",lat,lon);
            
            NSString * time=itemDic1[@"time"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *datefromdatabase= [formatter dateFromString:time];
            NSDateFormatter *df=[[NSDateFormatter alloc]init];
            NSLocale *usLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [df setLocale:usLocale];
            NSTimeZone *timeZone = [NSTimeZone localTimeZone];
            [df setTimeZone:timeZone];
            df.dateFormat=@"yyyy-MM-dd HH:mm:ss";
            NSDate *currentdate=[NSDate date];
            NSTimeInterval secondsBetween = [currentdate timeIntervalSinceDate:datefromdatabase];
            NSLog(@"the current date is %@; the date from database is %@",currentdate,datefromdatabase);
            int timeperiod=round(secondsBetween/60);
            if (timeperiod>120) {
                 NSLog(@"the green pin is %@",parkingname);
                [self marking1:lat withlng1:lon withname:parkingname];
            }
            else{
                 NSLog(@"the green flag is %@",parkingname);
                [self marking4:lat withlng:lon withname:parkingname];
                
            }
            
        }
    }
    if (self.TotalList.count>0) {
        for (int i=0; i<self.TotalList.count; i++) {
            NSDictionary *itemDic1=self.TotalList[i];
            NSString * lat=itemDic1[@"latitude"];
            NSString * lon=itemDic1[@"longitude"];
            NSString * parkingname=itemDic1[@"name"];
            [self marking:lat withlng:lon withname:parkingname];
        }
        
        
    }
    
}

- (void)marking:(NSString *)sl withlng:(NSString *)sln withname:(NSString *)name{
    float latitude = [sl floatValue];
    float longitude=[sln floatValue];
    CLLocationCoordinate2D place = CLLocationCoordinate2DMake(latitude,longitude);
    GMSMarker *placemarker = [[GMSMarker alloc] init];
    placemarker.position=place;
    placemarker.infoWindowAnchor = CGPointMake(0.10f, 0.45f);
    placemarker.map=self.mapView_;
    placemarker.title=name;
    
    
    
}



- (void)marking2:(NSString *)sl withlng:(NSString *)sln withname:(NSString *)name{
    float latitude = [sl floatValue];
    float longitude=[sln floatValue];
    CLLocationCoordinate2D place = CLLocationCoordinate2DMake(latitude,longitude);
    GMSMarker *placemarker = [[GMSMarker alloc] init];
    placemarker.icon=[GMSMarker markerImageWithColor:[UIColor blueColor]];
    placemarker.position=place;
    placemarker.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
    placemarker.map=self.mapView_;
    placemarker.title=name;
    
    
}

- (void)marking3:(NSString *)sl withlng:(NSString *)sln withname:(NSString *)name{
    float latitude = [sl floatValue];
    float longitude=[sln floatValue];
    CLLocationCoordinate2D place = CLLocationCoordinate2DMake(latitude,longitude);
    GMSMarker *placemarker = [[GMSMarker alloc] init];
    CGSize size=CGSizeMake(50, 50);
    UIImage * resizedImageicon= [self resizeImage:[UIImage imageNamed:@"new-map-marker.png"] imageSize:size];
    placemarker.icon=resizedImageicon;
    placemarker.position=place;
    placemarker.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
    placemarker.map=self.mapView_;
    placemarker.title=name;
    
}

- (void)marking4:(NSString *)sl withlng:(NSString *)sln withname:(NSString *)name{
    float latitude = [sl floatValue];
    float longitude=[sln floatValue];
    CLLocationCoordinate2D place = CLLocationCoordinate2DMake(latitude,longitude);
    GMSMarker *placemarker = [[GMSMarker alloc] init];
    CGSize size=CGSizeMake(50, 50);
    UIImage * resizedImageicon= [self resizeImage:[UIImage imageNamed:@"green-marker.png"] imageSize:size];
    placemarker.icon=resizedImageicon;
    placemarker.position=place;
    placemarker.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
    placemarker.map=self.mapView_;
    placemarker.title=name;
    
}

- (void)marking1:(NSString *)sl withlng1:(NSString *)sln withname:(NSString *)name{
    float latitude = [sl floatValue];
    float longitude=[sln floatValue];
    CLLocationCoordinate2D place = CLLocationCoordinate2DMake(latitude,longitude);
    GMSMarker *placemarker = [[GMSMarker alloc] init];
    placemarker.icon=[GMSMarker markerImageWithColor:[UIColor greenColor]];
    placemarker.position=place;
    placemarker.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
    placemarker.map=self.mapView_;
    placemarker.title=name;
    
    
    
    
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    NSLog(@"fds");
    NSLog(@"fff %f",marker.position.latitude);
    [mapView setSelectedMarker:marker];
    return YES;
}

- (void)mapViewDirection:(GMSMapView *)mapView didTapAtCoordinate:
(CLLocationCoordinate2D)coordinate {
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
                                                                 coordinate.latitude,
                                                                 coordinate.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    
    CLLocationCoordinate2D position1 = CLLocationCoordinate2DMake(latitudes,longitudes);
    
    GMSMarker *marker1 = [GMSMarker markerWithPosition:position1];
    
    [waypoints_ addObject:marker];
    [waypoints_ addObject:marker1];
    NSLog(@"the count is %lu",(unsigned long)waypoints_.count);
    NSLog(@"the first one is %@",[waypoints_ objectAtIndex:0]);
    NSLog(@"the first one is %@",[waypoints_ objectAtIndex:1]);
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                coordinate.latitude,coordinate.longitude];
    
    NSString *positionString1 = [[NSString alloc] initWithFormat:@"%f,%f",latitudes,longitudes];
    
    
    
    [waypointStrings_ addObject:positionString];
    [waypointStrings_ addObject:positionString1];
    
    
    if([waypoints_ count]>1){
        NSString *sensor = @"false";
        NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                               nil];
        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                          forKeys:keys];
        MDDirectionService *mds=[[MDDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                   withSelector:selector
                   withDelegate:self];
        
    }
    [waypointStrings_ removeAllObjects];
    [waypoints_ removeAllObjects];
    
}
- (void)addDirections:(NSDictionary *)json {
    NSDictionary *routes = [json objectForKey:@"routes"][0];
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polylinetotal=polyline;
    polylinetotal.strokeWidth = 7;
    polylinetotal.strokeColor = [UIColor greenColor];
    polylinetotal.map = self.mapView_;
    pi=1;
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation=[locations lastObject];
    CLLocationCoordinate2D coor=currentLocation.coordinate;
}

-(void)viewDidDisappear:(BOOL)animated{
    [locationManager stopUpdatingLocation];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
