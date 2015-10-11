//
//  PersonalViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/22/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView reloadData];
    self.personalList=[[NSMutableArray alloc]init];
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
    
    NSString *urlStr=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/onenearbyperson.php"];
    NSURL *url=[NSURL URLWithString:urlStr];
    
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
    if (receivedUrlArr.count>0) {
        for (int i=0; i<receivedUrlArr.count; i++) {
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
            NSString * libraryname=itemDic1[@"libraryname"];
            self.personalList[i]=@{@"iid":iid,@"time":time,@"latitude":latitude,@"longitude":longitude,@"city":city,@"state":state,@"zip":zip,@"street":street,@"userid":userid,@"type":type,@"parkingname":parkingname,@"likecount":likecount,@"username":username,@"portrait":portrait,@"reputation":reputation,@"temv":temv,@"humv":humv,@"noiselevel":noiselevel,@"accx":accx,@"accy":accy,@"accz":accz,@"rotx":rotx,@"roty":roty,@"rotz":rotz,@"grax":grax,@"gray":gray,@"graz":graz,@"imagename":imagename,@"note":note,@"libraryname":libraryname};
        }
        NSLog(@"the list llllllllllllllllllllllllllll   %d",self.personalList.count);
 
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.personalList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* CellIdentifier =[NSString stringWithFormat:@"%@%ld", @"PersonalMainPageTableViewCell",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil != cell){
        return cell;
    }
    cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalMainPageTableViewCell" owner:self options:nil] lastObject];
    cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    ((PersonalMainPageTableViewCell *)cell).username.text=[self.personalList objectAtIndex:indexPath.row][@"username"];
    ((PersonalMainPageTableViewCell *)cell).note.text=[self.personalList objectAtIndex:indexPath.row][@"note"];
    ((PersonalMainPageTableViewCell *)cell).time.text=[self.personalList objectAtIndex:indexPath.row][@"time"];
    ((PersonalMainPageTableViewCell *)cell).count.text=[self.personalList objectAtIndex:indexPath.row][@"likecount"];
    
    
    
    NSString * street=[self.personalList objectAtIndex:indexPath.row][@"street"];
    NSString * city=[self.personalList objectAtIndex:indexPath.row][@"city"];
    NSString * state=[self.personalList objectAtIndex:indexPath.row][@"state"];
    NSString * zip=[self.personalList objectAtIndex:indexPath.row][@"zip"];
    NSString * address=[street stringByAppendingString:@" "];
    address=[address stringByAppendingString:city];
    address=[address stringByAppendingString:@","];
    address=[address stringByAppendingString:state];
    address=[address stringByAppendingString:@" "];
    address=[address stringByAppendingString:zip];
    ((PersonalMainPageTableViewCell *)cell).address.text=address;
    
    
    NSString * parkingtype=[self.personalList objectAtIndex:indexPath.row][@"type"];
    if ([parkingtype isEqualToString:@"Parking"]) {
        NSString * parkingname=[self.personalList objectAtIndex:indexPath.row][@"parkingname"];
        NSString * totalparkinginfo=[parkingtype stringByAppendingString:@":"];
        totalparkinginfo=[totalparkinginfo stringByAppendingString:parkingname];
        ((PersonalMainPageTableViewCell *)cell).type.text=totalparkinginfo;
        
        NSString * temperature=[self.personalList objectAtIndex:indexPath.row][@"temv"];
        NSString * humidity=[self.personalList objectAtIndex:indexPath.row][@"humv"];
         NSString * totalcharacter=[NSString stringWithFormat:@"%@%@°C , Humidity:%@%%rH",@"Temperature:",temperature,humidity];
        ((PersonalMainPageTableViewCell *)cell).character.text=totalcharacter;
   }
    else{
        NSString * parkingname=[self.personalList objectAtIndex:indexPath.row][@"libraryname"];
        ((PersonalMainPageTableViewCell *)cell).type.text=parkingname;

        NSString * noiselevel=[self.personalList objectAtIndex:indexPath.row][@"noiselevel"];
        NSArray * tt=[noiselevel componentsSeparatedByString:@")"];
        NSString * first=tt[0];
        NSString * totalcharacter=[NSString stringWithFormat:@"NoiseLevel:%@dB)",first];
        ((PersonalMainPageTableViewCell *)cell).character.text=totalcharacter;
    }
    
    NSString * portraitstring=[self.personalList objectAtIndex:indexPath.row][@"portrait"];
    NSString *portraitImageURL = [NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/uploads/%@.png",portraitstring];
    NSData *portraitimageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:portraitImageURL]];
    
    CGSize size=CGSizeMake(36, 36);//set the width and height
    UIImage * resizedImage= [self resizeImage:[UIImage imageWithData:portraitimageData] imageSize:size];
    ((PersonalMainPageTableViewCell *)cell).headIcon.image=resizedImage;
    NSString * totalstring=[self.personalList objectAtIndex:indexPath.row][@"imagename"];
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
        ((PersonalMainPageTableViewCell *)cell).image1.image=resizedImage;
    }
    if ([s isEqualToString:@"no"]) {
    }
    else{
        NSString *ImageURL = [NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/uploads/%@.png",s];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
        CGSize size=CGSizeMake(80, 80);//set the width and height
        UIImage * resizedImage= [self resizeImage:[UIImage imageWithData:imageData] imageSize:size];
        ((PersonalMainPageTableViewCell *)cell).image2.image=resizedImage;
         }
    if ([t isEqualToString:@"no"]) {
    }
    else {
        NSString *ImageURL = [NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/uploads/%@.png",t];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
        CGSize size=CGSizeMake(80, 80);//set the width and height
        UIImage * resizedImage= [self resizeImage:[UIImage imageWithData:imageData] imageSize:size];
        ((PersonalMainPageTableViewCell *)cell).image3.image=resizedImage;
         }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 290;
    return height;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
