//
//  HomeViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/18/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property (strong,nonatomic)NSMutableArray * uploadlist;
@end
NSString * isadded;
NSString * isdeleted;
int ccc;
int index1;
int index2;
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView reloadData];
    _uploadlist=[[NSMutableArray alloc]init];
    index1=0;
    index2=0;
    UITableViewController *tableViewController =[[UITableViewController alloc]init];
    tableViewController.tableView=self.tableView;
    UIRefreshControl * refresh=[[UIRefreshControl alloc]init];
    refresh.attributedTitle=[[NSAttributedString alloc]initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl=refresh;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showMenu:(id)sender{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    return self.uploadlist.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    NSString* CellIdentifier =[NSString stringWithFormat:@"%@%ld", @"PersonalMainPageTableViewCell",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalMainPageTableViewCell" owner:self options:nil] lastObject];
    cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    ((PersonalMainPageTableViewCell *)cell).username.text=[_uploadlist objectAtIndex:indexPath.row][@"username"];
    ((PersonalMainPageTableViewCell *)cell).note.text=[_uploadlist objectAtIndex:indexPath.row][@"note"];
    ((PersonalMainPageTableViewCell *)cell).time.text=[_uploadlist objectAtIndex:indexPath.row][@"time"];
    NSString * scount=[_uploadlist objectAtIndex:indexPath.row][@"likecount"];
    ((PersonalMainPageTableViewCell *)cell).count.text=scount;
    
    ccc=[scount intValue];
    
    ((PersonalMainPageTableViewCell *)cell).uid=self.uid;
    ((PersonalMainPageTableViewCell *)cell).rid=[_uploadlist objectAtIndex:indexPath.row][@"iid"];

    NSString * parkingtype=[_uploadlist objectAtIndex:indexPath.row][@"type"];
    
    if ([parkingtype isEqualToString:@"Parking"]) {
        NSString * parkingname=[_uploadlist objectAtIndex:indexPath.row][@"parkingname"];
        NSString * totalparkinginfo=[parkingtype stringByAppendingString:@":"];
        totalparkinginfo=[totalparkinginfo stringByAppendingString:parkingname];
        ((PersonalMainPageTableViewCell *)cell).type.text=totalparkinginfo;
        
        NSString * temperature=[_uploadlist objectAtIndex:indexPath.row][@"temv"];
        NSString * humidity=[_uploadlist objectAtIndex:indexPath.row][@"humv"];
        NSString * totalcharacter=[NSString stringWithFormat:@"%@%@°C , Humidity:%@%%rH",@"Temperature:",temperature,humidity];
        
        ((PersonalMainPageTableViewCell *)cell).character.text=totalcharacter;
    }
    else{
        NSString * parkingname=[_uploadlist objectAtIndex:indexPath.row][@"libraryname"];
        ((PersonalMainPageTableViewCell *)cell).type.text=parkingname;
        
        NSString * noiselevel=[_uploadlist objectAtIndex:indexPath.row][@"noiselevel"];
        NSArray * tt=[noiselevel componentsSeparatedByString:@")"];
        NSString * first=tt[0];
        NSString * totalcharacter=[NSString stringWithFormat:@"Noise Level:%@dB)",first];
       ((PersonalMainPageTableViewCell *)cell).character.text=totalcharacter;
    }
   
    
    NSString * street=[_uploadlist objectAtIndex:indexPath.row][@"street"];
    NSString * city=[_uploadlist objectAtIndex:indexPath.row][@"city"];
    NSString * state=[_uploadlist objectAtIndex:indexPath.row][@"state"];
    NSString * zip=[_uploadlist objectAtIndex:indexPath.row][@"zip"];
    NSString * address=[street stringByAppendingString:@" "];
    address=[address stringByAppendingString:city];
    address=[address stringByAppendingString:@","];
    address=[address stringByAppendingString:state];
    address=[address stringByAppendingString:@" "];
    address=[address stringByAppendingString:zip];
    ((PersonalMainPageTableViewCell *)cell).address.text=address;
    
    CGSize size1=CGSizeMake(35, 35);
    CGSize size=CGSizeMake(80, 80);
    
    NSString * portraitstring=[self.uploadlist objectAtIndex:indexPath.row][@"portrait"];
    NSString *portraitImageURL = [NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/uploads/%@.png",portraitstring];
    NSData *portraitimageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:portraitImageURL]];
    ((PersonalMainPageTableViewCell *)cell).headIcon.image=[self resizeImage:[UIImage imageWithData:portraitimageData] imageSize:size1];
    NSString * totalstring=[self.uploadlist objectAtIndex:indexPath.row][@"imagename"];
    NSString * f=@"no";
    NSString * s=@"no";
    NSString * t=@"no";
    if ([totalstring isEqualToString:@"NO"]) {
    }
    else{
        NSArray* foo1 = [totalstring componentsSeparatedByString: @"&"];
        if (foo1.count==2) {
            f=[foo1 objectAtIndex:1];
        }
        else if (foo1.count==3) {
            f=[foo1 objectAtIndex:1];
            s=[foo1 objectAtIndex:2];
        }
        else{
            f=[foo1 objectAtIndex:1];
            s=[foo1 objectAtIndex:2];
            t=[foo1 objectAtIndex:3];
        }
        
    }
        if ([f isEqualToString:@"no"]) {
    }
    else{
        NSString *ImageURL = [NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/uploads/%@.png",f];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
        ((PersonalMainPageTableViewCell *)cell).image1.image=[self resizeImage:[UIImage imageWithData:imageData] imageSize:size];
        
    }
    if ([s isEqualToString:@"no"]) {
    }
    else{
        NSString *ImageURL = [NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/uploads/%@.png",s];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
        ((PersonalMainPageTableViewCell *)cell).image2.image=[self resizeImage:[UIImage imageWithData:imageData] imageSize:size];
    }
    if ([t isEqualToString:@"no"]) {
    }
    else {
        NSString *ImageURL = [NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/uploads/%@.png",t];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
        ((PersonalMainPageTableViewCell *)cell).image3.image=[self resizeImage:[UIImage imageWithData:imageData] imageSize:size];
    }
    NSString * rid=[_uploadlist objectAtIndex:indexPath.row][@"iid"];
    NSString * uid=self.uid;
    NSLog(@"THE 998989898989 IS %@  %@",rid,uid);
    NSString * result=[self addReputation:uid withRid:rid];
    if ([result isEqualToString:@"NO"]) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        button.tag=indexPath.row;
        
        [button addTarget:self
         
                   action:@selector(aMethod:) forControlEvents:UIControlEventTouchDown];
        
        
        [button setImage:[UIImage imageNamed:@"2"]  forState:UIControlStateNormal];
        
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.5)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
       
        [button.layer addAnimation:k forKey:@"SHOW"];

        
        button.frame = CGRectMake(5.0, 259.0, 30.0, 40);
        
        [cell.contentView addSubview:button];
        
    }
    
    
    else if ([result isEqualToString:@"YES"]){
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        button.tag=indexPath.row;
        
        [button addTarget:self
         
                   action:@selector(aMethod1:) forControlEvents:UIControlEventTouchDown];
       
        [button setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.5)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        
        [button.layer addAnimation:k forKey:@"SHOW"];
        
        button.frame = CGRectMake(5.0, 259.0, 30.0, 40);
        
        [cell.contentView addSubview:button];
        
    }
    
 
    
    
    if ([isadded isEqualToString:@"YES"]) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        button.tag=indexPath.row;
        
        [button addTarget:self
         
                   action:@selector(aMethod1:) forControlEvents:UIControlEventTouchDown];
      
        [button setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.5)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        [button.layer addAnimation:k forKey:@"SHOW"];
        button.frame = CGRectMake(5.0, 259.0, 30.0, 40);
        [cell.contentView addSubview:button];
        index1=index1+1;
        if (index1>index2) {
            NSString * cc=((PersonalMainPageTableViewCell *)cell).count.text;
            int icc=[cc intValue];
            icc=icc+1;
            ((PersonalMainPageTableViewCell *)cell).count.text=[NSString stringWithFormat:@"%d",icc];

        }
        
        else{
            NSString * cc=((PersonalMainPageTableViewCell *)cell).count.text;
            int icc=[cc intValue];
            icc=icc;
            ((PersonalMainPageTableViewCell *)cell).count.text=[NSString stringWithFormat:@"%d",icc];
            
        }
        index1=index1+1;
        isadded=@"NO";
    }

    
    if ([isdeleted isEqualToString:@"YES"]) {
        
        index2=index2+1;
        NSLog(@"the result is 08888888 %@",result);
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        button.tag=indexPath.row;
        
        [button addTarget:self
         
                   action:@selector(aMethod:) forControlEvents:UIControlEventTouchDown];
     
        [button setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.5)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        
        [button.layer addAnimation:k forKey:@"SHOW"];
        
        button.frame = CGRectMake(5.0, 259.0, 30.0, 40);
        
        [cell.contentView addSubview:button];
        

    
        if(index2>index1){
                        NSString * cc=((PersonalMainPageTableViewCell *)cell).count.text;
                        int icc=[cc intValue];
                        icc=icc-1;
                        ((PersonalMainPageTableViewCell *)cell).count.text=[NSString stringWithFormat:@"%d",icc];
        }
        
        else{
            NSString * cc=((PersonalMainPageTableViewCell *)cell).count.text;
            int icc=[cc intValue];
            icc=icc;
            ((PersonalMainPageTableViewCell *)cell).count.text=[NSString stringWithFormat:@"%d",icc];
        }
        index2=index2+1;
               isdeleted=@"NO";
    }

       return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 290;
    return height;
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

-(void)aMethod:(UIButton*)sender

{
    
    int this=sender.tag;
    
    NSString * thisid=[self.uploadlist objectAtIndex:this][@"iid"];
    NSString * person=[self.uploadlist objectAtIndex:this][@"userid"];
    NSString * whoid=self.uid;
    
    
    NSLog(@"UUU UID IS %@",whoid);
    NSLog(@"THE THING ID  IS %@",thisid);
    [self addToGPS:thisid];
    [self addToUser:person];
    [self addReputation1:whoid withrid:thisid];
    
    sender.hidden=YES;
   CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    NSLog(@"the 888888  index path %@",indexPath);

    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
  
    
}



-(void)addToGPS:(NSString *) thisid{
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/addzctogps.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    NSString *body=[NSString stringWithFormat:@"rid=%@",thisid];
    NSMutableURLRequest *request2=[NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request2 delegate:self];
    
}
-(void)addToUser:(NSString *) person{
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/addxinyutoperson.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    NSLog(@"the pppppp *********** is %@",person);
    
    NSString *body=[NSString stringWithFormat:@"uuid=%@",person];
    NSMutableURLRequest *request2=[NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request2 delegate:self];
  
    

}

-(void)addReputation1:(NSString *) whoid withrid:(NSString *)thisid{
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/addzanconnectpeople.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    
    NSLog(@"QQQQQQQQQQQQQQ %@ QQQQQQQQQQQ %@",whoid,thisid);
    NSString *body=[NSString stringWithFormat:@"uid=%@&rid=%@",whoid,thisid];
    NSMutableURLRequest *request2=[NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request2 delegate:self];
    
    isadded=@"YES";
    
}


//delete the zan

-(void)aMethod1:(UIButton*)sender

{
    
    int this=sender.tag;
    
    NSString * thisid=[self.uploadlist objectAtIndex:this][@"iid"];
    NSString * whoid=self.uid;
    NSString * person=[self.uploadlist objectAtIndex:this][@"userid"];
    
    NSLog(@"UUU UID IS %@",whoid);
    NSLog(@"THE THING ID  IS %@",thisid);
    [self deleteToGPS:thisid];
    [self deleteToUser:person];
    [self deleteReputation:whoid withrid:thisid];
    
    sender.hidden=YES;
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    NSLog(@"the 888888  index path %@",indexPath);
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


-(void)deleteToGPS:(NSString *) thisid{
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/deletezctogps.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    NSString *body=[NSString stringWithFormat:@"rid=%@",thisid];
    NSMutableURLRequest *request2=[NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request2 delegate:self];
    
}
-(void)deleteToUser:(NSString *) person{
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/deletexinyutoperson.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    NSString *body=[NSString stringWithFormat:@"uid=%@",person];
    NSMutableURLRequest *request2=[NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request2 delegate:self];
}

-(void)deleteReputation:(NSString *) whoid withrid:(NSString *)thisid{
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/deletezanconnectpeople.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    
    NSLog(@"QQQQQQQQQQQQQQ %@ QQQQQQQQQQQ %@",whoid,thisid);
    NSString *body=[NSString stringWithFormat:@"uid=%@&rid=%@",whoid,thisid];
    NSMutableURLRequest *request2=[NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request2 delegate:self];
    
    isdeleted=@"YES";
    
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

-(void)start{
    NSData *urlData;
    NSMutableArray *receivedUrlArr;
    
    NSString *urlStr=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/gettotalinformation.php"];
    NSURL *url=[NSURL URLWithString:urlStr];
    
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    
    NSURLConnection *theConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    NSError *requestError = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    urlData = [NSURLConnection sendSynchronousRequest:request
                                    returningResponse:&response
                                                error:&requestError];
    
    receivedUrlArr = [[NSMutableArray alloc]init];
    receivedUrlArr=[NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:nil];
    
    for (int i=(int)receivedUrlArr.count-1; i>=0; i--) {
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
        NSString * libraryname=itemDic1[@"libraryname"];
        NSString * likecount=itemDic1[@"likecount"];
        NSString * username=itemDic1[@"username"];
        NSString * portrait=itemDic1[@"portrait"];
        NSString * reputation=itemDic1[@"reputation"];
        NSString * temv=itemDic1[@"temv"];
        NSString * humv=itemDic1[@"humv"];
        NSString * noiselevel=itemDic1[@"noiselevel"];
        NSString * accx=itemDic1[@"accx"];
        NSString * accy=itemDic1[@"accy"];
        NSString * accz=itemDic1[@"accz"];
        NSString * rotx=itemDic1[@"rotx"];
        NSString * roty=itemDic1[@"roty"];
        NSString * rotz=itemDic1[@"rotz"];
        NSString * grax=itemDic1[@"grax"];
        NSString * gray=itemDic1[@"gray"];
        NSString * graz=itemDic1[@"graz"];
        NSString * imagename=itemDic1[@"imagename"];
        NSString * note=itemDic1[@"note"];
        
        _uploadlist[receivedUrlArr.count-i-1]=@{@"iid":iid,@"time":time,@"latitude":latitude,@"longitude":longitude,@"city":city,@"state":state,@"zip":zip,@"street":street,@"userid":userid,@"type":type,@"parkingname":parkingname,@"likecount":likecount,@"libraryname":libraryname,@"username":username,@"portrait":portrait,@"reputation":reputation,@"temv":temv,@"humv":humv,@"noiselevel":noiselevel,@"accx":accx,@"accy":accy,@"accz":accz,@"rotx":rotx,@"roty":roty,@"rotz":rotz,@"grax":grax,@"gray":gray,@"graz":graz,@"imagename":imagename,@"note":note};
        
        
    }
    [self.tableView reloadData];
}


@end
