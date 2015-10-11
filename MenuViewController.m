//
//  MenuViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/18/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "MenuViewController.h"
#import "HomeViewController.h"
#import "SecondViewController.h"
#import "NavigationViewController.h"
#import "UIViewControllerFrostedViewController.h"
#import "RankingViewController.h"
#import "ViewController.h"
#import "ClickImage.h"
#define PI 3.1415926



@interface MenuViewController ()
{
CLLocationManager *locationManager;
}
@property(strong,nonatomic)NSMutableArray * list00;
@end

@implementation MenuViewController
NSData * urlData;
NSMutableArray * receivedUrlArr;
NSString * username;
NSString * password;
NSString * email;
NSString * birthday;
NSString * gender;
NSString * sign;
NSString * profileString;
NSData * profileData;

float longitude;
float latitude;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.list00=[[NSMutableArray alloc]initWithCapacity:5];
    NSLog(@"the iii %@",self.uid);
    
    
    
   
}
#pragma mark -
#pragma mark UITableView Delegate

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NavigationViewController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        ModifyInfoViewController * modifyInfo=[[ModifyInfoViewController alloc]initWithNibName:@"ModifyInfoViewController" bundle:nil];
        modifyInfo.uid=self.uid;
        [self presentViewController:modifyInfo animated:YES completion:nil];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        OwnViewController * own=[[OwnViewController alloc]initWithNibName:@"OwnViewController" bundle:nil];
        own.uid=self.uid;
        [self presentViewController:own animated:YES completion:nil];
        
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
     RankingViewController * ranking=[[RankingViewController alloc]initWithNibName:@"RankingViewController" bundle:nil];
    [self presentViewController:ranking animated:YES completion:nil];
        
    }
    if (indexPath.section==1 && indexPath.row==1) {
        
        ReputationViewController * reputation=[[ReputationViewController alloc]initWithNibName:@"ReputationViewController" bundle:nil];
        reputation.uid=self.uid;
        [self presentViewController:reputation animated:YES completion:nil];
    }
    if (indexPath.section==1 && indexPath.row==2) {
        OwnReputationViewController * ownreputation=[[OwnReputationViewController alloc]initWithNibName:@"OwnReputationViewController" bundle:nil];
        ownreputation.uid=self.uid;
        [self presentViewController:ownreputation animated:YES completion:nil];
        
        
        
        
        
    }
    if (indexPath.section==2 && indexPath.row==0) {
        [self searchnearbyperson];
        NearbyPersonViewController * nea=[[NearbyPersonViewController alloc]initWithNibName:@"NearbyPersonViewController" bundle:nil];
        nea.peopleList=self.list00;
        [self presentViewController:nea animated:YES completion:nil];
    }

    if (indexPath.section==2 && indexPath.row==1) {
        UIStoryboard *str = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
           ViewController *login =[str instantiateViewControllerWithIdentifier:@"log"];
        [self presentViewController:login animated:YES completion:nil];
       [self dismissViewControllerAnimated:YES completion:nil];
    }
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSInteger rows=0;
    switch (sectionIndex) {
        case 0:
            rows=2;
            break;
        case 1:
            rows=3;
            break;
        case 2:
            rows=3;
            break;
    }
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"My Profile",@"My Posts"];
        UIImage * image2=[UIImage imageNamed:@"New Post-20"];
        UIImage * image1=[UIImage imageNamed:@"User-20"];
        NSArray * images=@[image1,image2];
        cell.imageView.image=images[indexPath.row];
        cell.textLabel.text = titles[indexPath.row];
    }
    if (indexPath.section == 1) {
        NSArray *titles = @[@"Reputation Ranking",@"Favorites", @"Likes"];
        UIImage * image1=[UIImage imageNamed:@"Rating-20"];
        UIImage * image2=[UIImage imageNamed:@"Like-20"];
        UIImage * image3=[UIImage imageNamed:@"Good Quality Filled-20"];
        NSArray * images=@[image1,image2,image3];
        cell.imageView.image=images[indexPath.row];
        cell.textLabel.text = titles[indexPath.row];
    }
    if (indexPath.section == 2) {
        UIImage * image1=[UIImage imageNamed:@"Date-20"];
        UIImage * image2=[UIImage imageNamed:@"Logout-20"];
               NSArray * images=@[image1,image2];
        if(indexPath.row==0 || indexPath.row==1){
        cell.imageView.image=images[indexPath.row];
        }
        NSArray *titles = @[@"People Nearby",@"Logout",@""];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"thhhhh %@",self.uid);
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        ClickImage *imageView = (ClickImage *)[[UIImageView alloc] initWithFrame:CGRectMake(-5, 40, 80, 80)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        NSString *urlStr=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/personal.php"];
        NSURL *url=[NSURL URLWithString:urlStr];
        NSString *body=[NSString stringWithFormat:@"id=%@",self.uid];
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
        NSURLConnection *theConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        NSError *requestError = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        urlData = [NSURLConnection sendSynchronousRequest:request
                                        returningResponse:&response
                                                    error:&requestError];
        
        
        
        
        receivedUrlArr = [[NSMutableArray alloc]init];
        
        receivedUrlArr=[NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"the length is%lu",(unsigned long)receivedUrlArr.count);
        
        for (int i=0; i<receivedUrlArr.count; i++) {
            NSDictionary *itemDic1=receivedUrlArr[i];
            username=itemDic1[@"username"];
            password=itemDic1[@"password"];
            email=itemDic1[@"email"];
            birthday=itemDic1[@"birthday"];
            gender=itemDic1[@"gender"];
            sign=itemDic1[@"sign"];
            profileString=itemDic1[@"profile"];
        }
        NSLog(@"the profileString is %@",profileString);
        NSString *portraitImageURL = [NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/uploads/%@.png",profileString];
        NSData *portraitimageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:portraitImageURL]];
        imageView.image=[UIImage imageWithData:portraitimageData];
        imageView.canClick=YES;
        //imageView.image=[UIImage imageNamed:@"Icon@2x.png"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 40.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        
        //tian and me different
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-35, 70, 0, 20)];
        //different
        label.text=username;
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:26];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(-10, 150, 0, 20)];
        label1.text =[@"About: " stringByAppendingString:sign];
        //label1.text = @"   Sign:";
        label1.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label1 sizeToFit];
        label1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        
        [view addSubview:imageView];
        [view addSubview:label];
        [view addSubview:label1];
        view;
    });

    [self getmylocation];
    
}
-(void)getmylocation{
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
    [ locationManager startUpdatingLocation];
     CLLocation *location = [locationManager location];
    longitude=location.coordinate.longitude;
    latitude=location.coordinate.latitude;
    NSString *ll=[NSString stringWithFormat:@"%3.5f",latitude];
    NSString * slatitude=ll;
    NSString * slongitude=[NSString stringWithFormat:@"%3.5f",longitude];
    
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    NSLocale *usLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [df setLocale:usLocale];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [df setTimeZone:timeZone];
    df.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    NSDate *date=[NSDate date];
    NSString * currentDate=[df stringFromDate:date];
   
    
    NSString *urlStr=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/updatemylocation.php"];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSString *body=[NSString stringWithFormat:@"userid=%@&username=%@&latitude=%@&longitude=%@&currenttime=%@",self.uid,username,slatitude,slongitude,currentDate];
    
    NSLog(@"id is this one %@,%@,%@",self.uid,slatitude,slongitude);
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
}

-(void)searchnearbyperson{
    
    NSData *urlData00;
    NSMutableArray *receivedUrlArr00;

    NSString *urlStr=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/getnearbyperson.php"];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSString * sla=[NSString stringWithFormat:@"%f",latitude];
    NSString * slo=[NSString stringWithFormat:@"%f",longitude];
    
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    NSLocale *usLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [df setLocale:usLocale];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [df setTimeZone:timeZone];
    df.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    NSDate *date=[NSDate date];
    NSString * currentDate=[df stringFromDate:date];
    
     NSString *body=[NSString stringWithFormat:@"lat=%@&lon=%@&uu=%@&currenttime=%@",sla,slo,self.uid,currentDate];
    NSLog(@"--------- %@",self.uid);
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    [request setHTTPMethod:@"POST"];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    NSError *requestError = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    urlData00 = [NSURLConnection sendSynchronousRequest:request
                                      returningResponse:&response
                                                  error:&requestError];
    
    receivedUrlArr00 = [[NSMutableArray alloc]init];
    receivedUrlArr00=[NSJSONSerialization JSONObjectWithData:urlData00 options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"the length is%lu",(unsigned long)receivedUrlArr00.count);
    
    
    
    if (receivedUrlArr00.count!=0) {
        for (int i=0; i<receivedUrlArr00.count; i++) {
            NSDictionary *itemDic1=receivedUrlArr00[i];
            NSString * imagestring=itemDic1[@"portrait"];
            
            NSString *portraitImageURL = [NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/uploads/%@.png",imagestring];
            NSData *portraitimageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:portraitImageURL]];
            
            /////
            UIImage * imageimage=[UIImage imageWithData:portraitimageData];
            NSString * lla=itemDic1[@"latitude"];
            NSString * llo=itemDic1[@"longitude"];
            float flla = [lla floatValue];
            float fllo= [llo floatValue];
            
            CLLocation *locA = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            CLLocation *locB = [[CLLocation alloc] initWithLatitude:flla longitude:fllo];
            CLLocationDistance Cdistance = [locA distanceFromLocation:locB];
            float distance=Cdistance*0.000621371;
            NSString * sdistance=[NSString stringWithFormat:@"%.2f Miles",distance];
            
            NSLog(@"the dddddd fdsfsaasfsad is %@,%@,%@",itemDic1[@"username"],itemDic1[@"userid"],sdistance);
            self.list00[i]=@{@"id":itemDic1[@"id"],@"distance":sdistance,@"username":itemDic1[@"username"],@"userid":itemDic1[@"userid"],@"portrait":imageimage};
        }
        for (int i=0; i<self.list00.count-1; i++) {
            for (int j=0; j<=self.list00.count-i-2; j++) {
                if ([self.list00[j][@"distance"] floatValue]>[self.list00[j+1][@"distance"] floatValue]) {
                    NSDictionary * dd=self.list00[j];
                    self.list00[j]=self.list00[j+1];
                    self.list00[j+1]=dd;
                }
            }
        }

    }
    
    
    }

    -(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
    {
        CLLocation *currentLocation=[locations lastObject];
        CLLocationCoordinate2D coor=currentLocation.coordinate;
        latitude=coor.latitude;
        longitude=coor.longitude;
    }






@end
