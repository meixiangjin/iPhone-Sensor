//
//  OwnReputationViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/23/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "OwnReputationViewController.h"

@interface OwnReputationViewController ()

@end

@implementation OwnReputationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView reloadData];
    self.navigationItem.title=@"My Liked Posts";
    UINavigationBar *myBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:myBar];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem=leftButton;
    [myBar pushNavigationItem:self.navigationItem animated:YES];
    // Do any additional setup after loading the view from its nib.
}
-(void)Back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [_tableView reloadData];
    NSData *urlData;
    NSMutableArray *receivedUrlArr;
    
    
    //new 8787
    self.reputationList=[[NSMutableArray alloc]initWithCapacity:6];
    //new 8787
    
    NSString *urlStr=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/showtablewholikeme.php"];
    NSURL *url=[NSURL URLWithString:urlStr];
    
    NSLog(@"00000=========+++++++++++++ %@",self.uid);
    
    NSString *body=[NSString stringWithFormat:@"userid=%@",self.uid];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    [request setHTTPMethod:@"POST"];
    
    
    NSURLConnection *theConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    NSError *requestError = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    urlData = [NSURLConnection sendSynchronousRequest:request
                                    returningResponse:&response
                                                error:&requestError];
    
    receivedUrlArr = [[NSMutableArray alloc]init];
    receivedUrlArr=[NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:nil];
    
 //   if (receivedUrlArr.count>0) {

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
        NSString * likecount=itemDic1[@"likecount"];
        NSString * username=itemDic1[@"username"];
        NSString * portrait=itemDic1[@"portrait"];
        NSString * reputation=itemDic1[@"reputation"];
        NSString * temv=itemDic1[@"temv"];
        NSString * humv=itemDic1[@"humv"];
        NSString * noiselevel=itemDic1[@"noiselevel"];
        NSString * libraryname=itemDic1[@"libraryname"];
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
        NSString * total=itemDic1[@"total"];

        self.reputationList[receivedUrlArr.count-i-1]=@{@"iid":iid,@"time":time,@"latitude":latitude,@"longitude":longitude,@"city":city,@"state":state,@"zip":zip,@"street":street,@"userid":userid,@"type":type,@"parkingname":parkingname,@"likecount":likecount,@"username":username,@"portrait":portrait,@"reputation":reputation,@"temv":temv,@"humv":humv,@"noiselevel":noiselevel,@"accx":accx,@"accy":accy,@"accz":accz,@"rotx":rotx,@"roty":roty,@"rotz":rotz,@"grax":grax,@"gray":gray,@"graz":graz,@"imagename":imagename,@"note":note,@"total":total,@"libraryname":libraryname};
        
        
    }
    [self.tableView reloadData];
 //   }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.reputationList.count;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* CellIdentifier =[NSString stringWithFormat:@"%@%ld", @"OwnReputationTableViewCell",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil != cell){
        return cell;
    }
    cell = [[[NSBundle mainBundle] loadNibNamed:@"OwnReputationTableViewCell" owner:self options:nil] lastObject];
    cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    ((OwnReputationTableViewCell *)cell).username.text=[self.reputationList objectAtIndex:indexPath.row][@"username"];
    
    
    
    NSString *str =[self.reputationList objectAtIndex:indexPath.row][@"total"];

    str = [str stringByReplacingOccurrencesOfString:@","
                                         withString:@" "];
    
    
    ((OwnReputationTableViewCell *)cell).names.text=str;
    
    NSString * totalstring=[self.reputationList objectAtIndex:indexPath.row][@"imagename"];
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
        UIImage * ii=[UIImage imageWithData:imageData];
        CGSize size=CGSizeMake(80, 80);//set the width and height
        UIImage * resizedImage= [self resizeImage:ii imageSize:size];
        ((OwnReputationTableViewCell *)cell).image1.image=resizedImage;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 150;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    MessageViewController * message=[[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
    message.username=[self.reputationList objectAtIndex:indexPath.row][@"username"];
    message.note=[self.reputationList objectAtIndex:indexPath.row][@"note"];

    message.time=[self.reputationList objectAtIndex:indexPath.row][@"time"];
    
    NSString * portraitstring=[self.reputationList objectAtIndex:indexPath.row][@"portrait"];
    NSString *portraitImageURL = [NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/uploads/%@.png",portraitstring];
    NSData *portraitimageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:portraitImageURL]];
    UIImage * ii=[UIImage imageWithData:portraitimageData];
    CGSize size=CGSizeMake(35, 35);//set the width and height
    UIImage * resizedImage= [self resizeImage:ii imageSize:size];
    message.headIcon=resizedImage;
    
    NSString * typing=[self.reputationList objectAtIndex:indexPath.row][@"type"];
    if ([typing isEqualToString:@"Parking"]) {
        NSString * parkingname=[self.reputationList objectAtIndex:indexPath.row][@"parkingname"];
        NSString * totalparkinginfo=[typing stringByAppendingString:@":"];
        totalparkinginfo=[totalparkinginfo stringByAppendingString:parkingname];
        message.type=totalparkinginfo;
        
        NSString * temperature=[self.reputationList objectAtIndex:indexPath.row][@"temv"];
        NSString * humidity=[self.reputationList objectAtIndex:indexPath.row][@"humv"];
        NSString * totalcharacter=[NSString stringWithFormat:@"%@%@°C , Humidity:%@%%rH",@"Temperature:",temperature,humidity];
        
        message.character=totalcharacter;

    }
    else{
        NSString * parkingname=[self.reputationList objectAtIndex:indexPath.row][@"libraryname"];
        message.type=parkingname;
        
        NSString * noiselevel=[self.reputationList objectAtIndex:indexPath.row][@"noiselevel"];
        NSArray * tt=[noiselevel componentsSeparatedByString:@")"];
        NSString * first=tt[0];
        NSString * totalcharacter=[NSString stringWithFormat:@"Noise Level:%@dB)",first];
        message.character=totalcharacter;
    }
    
    NSString * street=[self.reputationList objectAtIndex:indexPath.row][@"street"];
    NSString * city=[self.reputationList objectAtIndex:indexPath.row][@"city"];
    NSString * state=[self.reputationList objectAtIndex:indexPath.row][@"state"];
    NSString * zip=[self.reputationList objectAtIndex:indexPath.row][@"zip"];
    NSString * address=[street stringByAppendingString:@" "];
    address=[address stringByAppendingString:city];
    address=[address stringByAppendingString:@","];
    address=[address stringByAppendingString:state];
    address=[address stringByAppendingString:@" "];
    address=[address stringByAppendingString:zip];
    message.address=address;
    
    
    NSString * totalstring=[self.reputationList objectAtIndex:indexPath.row][@"imagename"];
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
        CGSize size=CGSizeMake(80, 80);//set the width and height
        UIImage * resizedImage= [self resizeImage:[UIImage imageWithData:imageData] imageSize:size];
        message.image1=resizedImage;
    }
    if ([s isEqualToString:@"no"]) {
    }
    else{
        NSString *ImageURL = [NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/uploads/%@.png",s];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
        
        CGSize size=CGSizeMake(80, 80);//set the width and height
        UIImage * resizedImage= [self resizeImage:[UIImage imageWithData:imageData] imageSize:size];
        message.image2=resizedImage;
    }
    if ([t isEqualToString:@"no"]) {
    }
    else {
        NSString *ImageURL = [NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/uploads/%@.png",t];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
        
        CGSize size=CGSizeMake(80, 80);//set the width and height
        UIImage * resizedImage= [self resizeImage:[UIImage imageWithData:imageData] imageSize:size];
        message.image3=resizedImage;
    }
    message.navigationItem.title=@"Like Mine";
    [self presentViewController:message animated:YES completion:nil];
    
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
