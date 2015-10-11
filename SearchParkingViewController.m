//
//  SearchParkingViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/26/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "SearchParkingViewController.h"

@interface SearchParkingViewController ()

@end

@implementation SearchParkingViewController
NSString * ageforregistermin;
NSString * ageforregistermax;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.city=@"anything";
    self.zip=@"anything";
    self.parkingname=@"anything";
    self.state=@"anything";
    self.tmin=@"-40";
    self.tmax=@"50";
    self.hmin=@"0";
    self.hmax=@"100";
    self.likemin=@"0";
    self.likemax=@"1000000";
    self.time=@"0000-00-00";
    self.fcount=@"0";
    self.username=@"anything";
    self.ageforregister=@"0";
    UITableViewController *tableViewController =[[UITableViewController alloc]init];
    tableViewController.tableView=self.tableView;
    UIRefreshControl * refresh=[[UIRefreshControl alloc]init];
    refresh.attributedTitle=[[NSAttributedString alloc]initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl=refresh;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView reloadData];
    [self start];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.uploads.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* CellIdentifier =[NSString stringWithFormat:@"%@%ld", @"PersonalMainPageTableViewCell",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalMainPageTableViewCell" owner:self options:nil] lastObject];
    cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    ((PersonalMainPageTableViewCell *)cell).username.text=[_uploads objectAtIndex:indexPath.row][@"username"];
    ((PersonalMainPageTableViewCell *)cell).note.text=[_uploads objectAtIndex:indexPath.row][@"note"];
    
    
    NSString * parkingtype=[_uploads objectAtIndex:indexPath.row][@"type"];
    NSString * parkingname=[_uploads objectAtIndex:indexPath.row][@"parkingname"];
    NSString * totalparkinginfo=[parkingtype stringByAppendingString:@":"];
    totalparkinginfo=[totalparkinginfo stringByAppendingString:parkingname];
    ((PersonalMainPageTableViewCell *)cell).type.text=totalparkinginfo;
    NSString * temperature=[_uploads objectAtIndex:indexPath.row][@"temv"];
    NSString * humidity=[_uploads objectAtIndex:indexPath.row][@"humv"];
    NSString * totalcharacter=[NSString stringWithFormat:@"%@%@°C , Humidity:%@%%rH",@"Temperature:",temperature,humidity];
    ((PersonalMainPageTableViewCell *)cell).character.text=totalcharacter;
    NSString * street=[_uploads objectAtIndex:indexPath.row][@"street"];
    NSString * city=[_uploads objectAtIndex:indexPath.row][@"city"];
    NSString * state=[_uploads objectAtIndex:indexPath.row][@"state"];
    NSString * zip=[_uploads objectAtIndex:indexPath.row][@"zip"];
    NSString * address=[street stringByAppendingString:@","];
    address=[address stringByAppendingString:city];
    address=[address stringByAppendingString:@","];
    address=[address stringByAppendingString:state];
    address=[address stringByAppendingString:@" "];
    address=[address stringByAppendingString:zip];
    ((PersonalMainPageTableViewCell *)cell).address.text=address;
    
    ((PersonalMainPageTableViewCell *)cell).time.text=[_uploads objectAtIndex:indexPath.row][@"time"];
    
    CGSize size1=CGSizeMake(35, 35);
    CGSize size=CGSizeMake(80, 80);//set the width and height
    
    NSString * name=[_uploads objectAtIndex:indexPath.row][@"portrait"];
    NSString *imageURL=[NSString stringWithFormat:@"%@%@.png",@"http://euryale.cs.uwlax.edu/uploads/",name];
    
    NSData *imageData= [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    UIImage * imageView=[UIImage imageWithData:imageData];
    UIImage * resizedImage= [self resizeImage:imageView imageSize:size1];
    ((PersonalMainPageTableViewCell *)cell).headIcon.image=resizedImage;
    NSString * totalstring=[self.uploads objectAtIndex:indexPath.row][@"imagename"];
    if ([totalstring isEqualToString:@"NO"]) {
        
    }
    else{
        NSArray * names=[[_uploads objectAtIndex:indexPath.row][@"imagename"] componentsSeparatedByString:@"&"];
        
        NSString *imageURL1=[NSString stringWithFormat:@"%@%@%@",@"http://euryale.cs.uwlax.edu/uploads/",names[1],@".png"];
        
        NSData *imageData1= [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL1]];
        UIImage * imageView1=[UIImage imageWithData:imageData1];
        UIImage * resizedImage1= [self resizeImage:imageView1 imageSize:size];
        ((PersonalMainPageTableViewCell *)cell).image1.image=resizedImage1;
        if (names.count>2 && names.count<4) {
            NSString *imageURL2=[NSString stringWithFormat:@"%@%@%@",@"http://euryale.cs.uwlax.edu/uploads/",names[2],@".png"];
            NSData *imageData2= [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL2]];
            UIImage * imageView2=[UIImage imageWithData:imageData2];
            UIImage * resizedImage2= [self resizeImage:imageView2 imageSize:size];
            ((PersonalMainPageTableViewCell *)cell).image2.image=resizedImage2;
        }
        if (names.count>3) {
            NSString *imageURL2=[NSString stringWithFormat:@"%@%@%@",@"http://euryale.cs.uwlax.edu/uploads/",names[2],@".png"];
            
            NSData *imageData2= [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL2]];
            UIImage * imageView2=[UIImage imageWithData:imageData2];
            UIImage * resizedImage2= [self resizeImage:imageView2 imageSize:size];
            ((PersonalMainPageTableViewCell *)cell).image2.image=resizedImage2;
            NSString *imageURL3=[NSString stringWithFormat:@"%@%@%@",@"http://euryale.cs.uwlax.edu/uploads/",names[3],@".png"];
            
            NSData *imageData3= [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL3]];
            UIImage * imageView3=[UIImage imageWithData:imageData3];
            UIImage * resizedImage3= [self resizeImage:imageView3 imageSize:size];
            ((PersonalMainPageTableViewCell *)cell).image3.image=resizedImage3;
        }
    }
    
    ((PersonalMainPageTableViewCell *)cell).uid=self.uid;
    ((PersonalMainPageTableViewCell *)cell).rid=[_uploads objectAtIndex:indexPath.row][@"iid"];
    
    NSString * rid=[_uploads objectAtIndex:indexPath.row][@"iid"];
    NSString * uid=self.uid;
    NSString * result=[self addReputation:uid withRid:rid];
    if ([result isEqualToString:@"NO"]) {
        ((PersonalMainPageTableViewCell *)cell).likeButton.hidden=NO;
    }
    else{
        ((PersonalMainPageTableViewCell *)cell).likeButton.hidden=YES;
    }
    ((PersonalMainPageTableViewCell *)cell).count.text=[_uploads objectAtIndex:indexPath.row][@"likecount"] ;
    
    return cell;
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 290;
    return height;
}
-(NSString *)addReputation:(NSString *)uid withRid:(NSString *)rid{
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/checkzan.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    NSString *body=[NSString stringWithFormat:@"uid=%@&rid=%@",uid,rid];
    NSMutableURLRequest *request2=[NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request2 delegate:self];
    NSError *requestError3 = [[NSError alloc] init];
    NSHTTPURLResponse *response3 = nil;
    NSData * urlData3 = [NSURLConnection sendSynchronousRequest:request2
                         
                                              returningResponse:&response3
                         
                                                          error:&requestError3];
    NSString *responseText = [[NSString alloc] initWithData:urlData3 encoding: NSASCIIStringEncoding];
    return responseText;
    
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString: @"searchdetail"]) {
        SearchTableViewController * Tctrl = (SearchTableViewController *) segue.destinationViewController;
        Tctrl.hidesBottomBarWhenPushed = YES;
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)start{
    NSData *urlData;
    NSMutableArray *receivedUrlArr;
    self.uploads=[[NSMutableArray alloc]initWithCapacity:5];
    NSString *urlStr=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/getSearchingParking.php"];
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    NSLocale *usLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [df setLocale:usLocale];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [df setTimeZone:timeZone];
    df.dateFormat=@"yyyy-MM-dd";
    NSDate *date=[NSDate date];
    NSString * currentDate=[df stringFromDate:date];
    
    NSArray * arraycurrentDate=[currentDate componentsSeparatedByString:@"-"];
    NSString * nowyear=arraycurrentDate[0];
    NSString * nowmonth=arraycurrentDate[1];
    NSString * nowday=arraycurrentDate[2];
    
    int ny=(int)[nowyear integerValue];
    int nm=(int)[nowmonth integerValue];
    int nd=(int)[nowday integerValue];
    
    
    int sg=(int)[self.ageforregister integerValue];
    int iresultyear=ny-sg;
    NSString * resultyear=[NSString stringWithFormat:@"%d-%@-%@",iresultyear,nowmonth,nowday];
    
    int count=0;
    if (![self.city isEqualToString:@"anything"]) {
        count++;
    }
    if (![self.state isEqualToString:@"anything"]) {
        count++;
    }
    if (![self.zip isEqualToString:@"anything"]) {
        count++;
    }
    self.fcount=[NSString stringWithFormat:@"%d",count];
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    NSString *body=[NSString stringWithFormat:@"likecountmin=%@&likecountmax=%@&tmin=%@&tmax=%@&hmin=%@&hmax=%@&city=%@&state=%@&zip=%@&time=%@&count=%@&type=%@&nmin=-100&nmax=100&username=%@&parkingname=%@&age=%@",self.likemin,self.likemax,self.tmin,self.tmax,self.hmin,self.hmax,self.city,self.state,self.zip,self.time,self.fcount,@"Parking",self.username,self.parkingname,resultyear];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    
    
    NSURLConnection *theConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    NSError *requestError = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    urlData = [NSURLConnection sendSynchronousRequest:request
                                    returningResponse:&response
                                                error:&requestError];
    NSString *receivedDataString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    if (![receivedDataString isEqualToString:@"NO"]) {
        
        
        receivedUrlArr = [[NSMutableArray alloc]init];
        receivedUrlArr=[NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:nil];
        
        for (int i=receivedUrlArr.count-1;i>=0;i--) {
            NSDictionary *itemDic1=receivedUrlArr[i];
            NSString * iid=itemDic1[@"id"];
            NSString * time=itemDic1[@"time"];
            NSString * latitude=itemDic1[@"latitude"];
            NSString * longitude=itemDic1[@"longitude"];
            NSString * city=itemDic1[@"city"];
            NSString * state=itemDic1[@"state"];
            NSString * zip=itemDic1[@"zip"];
            NSString * street=itemDic1[@"street"];
            NSString * userid=itemDic1[@"userid"];
            NSString * type=itemDic1[@"type"];
            NSString * parkingname=itemDic1[@"parkingname"];
            NSString * likecount=itemDic1[@"likecount"];
            NSString * username=itemDic1[@"username"];
            NSString * portrait=itemDic1[@"portrait"];
            NSString * temv=itemDic1[@"temv"];
            NSString * humv=itemDic1[@"humv"];
            NSString * imagename=itemDic1[@"imagename"];
            NSString * note=itemDic1[@"note"];
            
            self.uploads[receivedUrlArr.count-i-1]=@{@"iid":iid,@"time":time,@"latitude":latitude,@"longitude":longitude,@"city":city,@"state":state,@"zip":zip,@"street":street,@"userid":userid,@"type":type,@"parkingname":parkingname,@"likecount":likecount,@"username":username,@"portrait":portrait,@"temv":temv,@"humv":humv,@"imagename":imagename,@"note":note};
            
            
        }
        
    }
    [self.tableView reloadData];
    
    
}


-(void)refreshView:(UIRefreshControl *)refresh{
    refresh.attributedTitle=[[NSAttributedString alloc]initWithString:@"Refreshing data"];
    [self start];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString * lastUpdated=[NSString stringWithFormat:@"Last updated on %@",[formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle=[[NSAttributedString alloc]initWithString:lastUpdated];
    [refresh endRefreshing];
    
}

@end
