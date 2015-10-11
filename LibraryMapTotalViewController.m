//
//  LibraryMapTotalViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 2/1/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//
#import "LibraryMapTotalViewController.h"
static const CGFloat CalloutYOffset = 10.0f;
@interface LibraryMapTotalViewController (){
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
    
    NSString * dateclickcar;
    NSDate * currentdatetime;
    NSTimer *timer;
    NSString * thisaddress;
    
}

@end

@implementation LibraryMapTotalViewController

float latitude;
float longitude;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.TotalList=[[NSMutableArray alloc]init];
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    self.mapView_.myLocationEnabled=YES;
    self.mapView_.settings.myLocationButton = YES;
    
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager=[[CLLocationManager alloc]init];
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
    NSLog(@"the llll is %f",longitudes);
    //new
    //longitudes=-91.230789;
    //latitudes=43.791046;
    //new
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitudes longitude:longitudes zoom:14];
    self.mapView_.camera=camera;
    self.mapView_.delegate = self;
    self.mapView_.mapType=kGMSTypeNormal;
    
    // Do any additional setup after loading the view.
    
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
    [self getmapfromdatabase];
    
    
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
    thisaddress=mm.title;
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
    
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/FindFullStudyLocation.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    NSLog(@"the zip is %@",thisaddress);
    NSArray * arrayforaddress=[thisaddress componentsSeparatedByString:@","];
    NSString * street=arrayforaddress[0];
    NSString * city=arrayforaddress[1];
    NSString * stateandzip=arrayforaddress[2];
    NSArray * arraystateandzip=[stateandzip componentsSeparatedByString:@" "];
    NSString * state=arraystateandzip[0];
    NSString * zip=arraystateandzip[1];
    
    NSString *body=[NSString stringWithFormat:@"street=%@&city=%@&state=%@&zip=%@&time=%@",street,city,state,zip,dateclickcar];
    NSLog(@"the dateclickcar is ^^^^^^ %@",dateclickcar);
    NSLog(@"the state is ^^^^ %@",state);
    NSLog(@"the state is ^^^^ %@",street);
    NSLog(@"the state is ^^^^ %@",zip);
    NSLog(@"the state is ^^^^ %@",city);

    
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
            NSLog(@"the current state^^^^^^^^^^^^^ is %@",currentstate);
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
        notification.alertBody=@"There is no vacant space in this location!";
        notification.repeatInterval=0;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    CLLocationCoordinate2D anchor = marker.position;
    
    CGPoint point = [mapView.projection pointForCoordinate:anchor];
    NSString * tempstring=@"";
    NSArray * temparray=[marker.title componentsSeparatedByString:@","];
    if (temparray.count>1) {
        self.calloutView.title = temparray[0];
        for (int i=1; i<temparray.count; i++) {
            if (i==1) {
                tempstring=[NSString stringWithFormat:@"%@%@",tempstring,temparray[i]];
            }
            else{
                tempstring=[NSString stringWithFormat:@"%@,%@",tempstring,temparray[i]];
            }
            
        }
        self.calloutView.subtitle=tempstring;
    }
    
    self.calloutView.calloutOffset = CGPointMake(0, -CalloutYOffset);
    
    self.calloutView.hidden = NO;
    
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
        LibraryMapViewController *lctrl = [str instantiateViewControllerWithIdentifier:@"librarymap"];
        lctrl.lat=[NSString stringWithFormat:@"%f",self.mapView_.selectedMarker.position.latitude];
        lctrl.lon=[NSString stringWithFormat:@"%f",self.mapView_.selectedMarker.position.longitude];
        [self presentViewController: lctrl animated: YES completion: nil];
    }
}

-(void)getmapfromdatabase{
    NSString * sla=[NSString stringWithFormat:@"%f", latitudes];
    NSString * slo=[NSString stringWithFormat:@"%f", longitudes];
    
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/ParkingGoogle.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    NSString *body=[NSString stringWithFormat:@"lat=%@&lon=%@&type=Library",sla,slo];
    NSMutableURLRequest *request2=[NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request2 delegate:self];
    NSError *requestError2 = [[NSError alloc] init];
    NSHTTPURLResponse *response2 = nil;
    urlData5 = [NSURLConnection sendSynchronousRequest:request2
                                     returningResponse:&response2
                                                 error:&requestError2];
    
    receivedUrlArr1 = [[NSMutableArray alloc]init];
    receivedUrlArr1=[[NSJSONSerialization JSONObjectWithData:urlData5 options:NSJSONReadingAllowFragments error:nil] mutableCopy];
    
    if (receivedUrlArr1.count>0) {
        
        for (int i=0; i<=receivedUrlArr1.count-1; i++) {
            for (int j=i+1; j<receivedUrlArr1.count; j++) {
                
                float a=[receivedUrlArr1[j][@"latitude"] floatValue]-[receivedUrlArr1[i][@"latitude"] floatValue];
                float b=[receivedUrlArr1[j][@"longitude"] floatValue]-[receivedUrlArr1[i][@"longitude"] floatValue];
                NSString * atime=receivedUrlArr1[i][@"time"];
                NSString * btime=receivedUrlArr1[j][@"time"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate * adate=[formatter dateFromString:atime];
                NSDate * bdate=[formatter dateFromString:btime];
                NSComparisonResult result=[adate compare:bdate];
                
                if(a<0.0005 && a>-0.0005 && b<0.0005 && b>-0.0005){
                    if (result==NSOrderedDescending) {
                        [receivedUrlArr1 removeObjectAtIndex:j];
                    }
                    else{
                        [receivedUrlArr1 removeObjectAtIndex:i];
                    }
                }
            }
        }
        for (int i=0; i<=receivedUrlArr1.count-1; i++) {
            for (int j=i+1; j<receivedUrlArr1.count; j++) {
                float a=[receivedUrlArr1[j][@"latitude"] floatValue]-[receivedUrlArr1[i][@"latitude"] floatValue];
                float b=[receivedUrlArr1[j][@"longitude"] floatValue]-[receivedUrlArr1[i][@"longitude"] floatValue];
                NSString * atime=receivedUrlArr1[i][@"time"];
                NSString * btime=receivedUrlArr1[j][@"time"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate * adate=[formatter dateFromString:atime];
                NSDate * bdate=[formatter dateFromString:btime];
                NSComparisonResult result=[adate compare:bdate];
                if(a<0.0005 && a>-0.0005 && b<0.0005 && b>-0.0005){
                    if (result==NSOrderedDescending) {
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
            NSString * lat=itemDic1[@"latitude"];
            NSString * lon=itemDic1[@"longitude"];
            NSString * city=itemDic1[@"city"];
            NSString * state=itemDic1[@"state"];
            NSString * street=itemDic1[@"street"];
            NSString * zip=itemDic1[@"zip"];
            NSString * address=[NSString stringWithFormat:@"%@,%@,%@ %@",street,city,state,zip];
            int zuobiao=self.TotalList.count;
            self.TotalList[zuobiao]=@{@"latitude":lat,@"longitude":lon,@"address":address};
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
                [self marking1:lat withlng1:lon withAddress:address];
            }
            else{
                [self marking4:lat withlng:lon withname:address];
            }
            
        }
        
    }
    
}

- (void)marking1:(NSString *)sl withlng1:(NSString *)sln withAddress:(NSString *)address{
    latitude = [sl floatValue];
    longitude=[sln floatValue];
    CLLocationCoordinate2D place = CLLocationCoordinate2DMake(latitude,longitude);
    GMSMarker *placemarker = [[GMSMarker alloc] init];
    placemarker.icon=[GMSMarker markerImageWithColor:[UIColor greenColor]];
    placemarker.position=place;
    placemarker.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
    placemarker.map=self.mapView_;
    placemarker.title=address;
    
    
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
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
    NSLog(@"the routes is %@",routes);
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
-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end