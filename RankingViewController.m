//
//  RankingViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "RankingViewController.h"
#import "PersonalViewController.h"
@interface RankingViewController ()

@end

@implementation RankingViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView reloadData];
    self.navigationItem.title=@"Reputation Ranking";
    
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
    self.rankList=[[NSMutableArray alloc]init];
    NSString *urlStr=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/ranking.php"];
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
    
    for (int i=0; i<receivedUrlArr.count; i++) {
        NSDictionary *itemDic1=receivedUrlArr[i];
        NSString * username=itemDic1[@"username"];
        NSString * portrait=itemDic1[@"portrait"];
        NSString * reputation=itemDic1[@"reputation"];
        NSString * registertime=itemDic1[@"registertime"];
        NSString * uid=itemDic1[@"userid"];
        self.rankList[i]=@{@"username":username,@"portrait":portrait,@"reputation":reputation,@"registertime":registertime,@"userid":uid};
    }
    self.rankList =(NSMutableArray *) [self.rankList  sortedArrayUsingComparator: ^NSComparisonResult(id a, id b)
                                       
                                       {

                                           NSString *  rep1=[a objectForKey:@"reputation"];
                                           NSString * rep2=[b objectForKey:@"reputation"];
                                           int irep1=[rep1 integerValue];
                                           int irep2=[rep2 integerValue];
                                           if (irep1>irep2) {
                                               return (NSComparisonResult)NSOrderedAscending;
                                           } else if ( irep1<irep2) {
                                               return (NSComparisonResult)NSOrderedDescending;
                                           } else {
                                               return (NSComparisonResult)NSOrderedSame;
                                           }
                                           
                                       }];
    self.rankList =(NSMutableArray *) [self.rankList  sortedArrayUsingComparator: ^NSComparisonResult(id a, id b)
{
            NSNumber * rep1=[a objectForKey:@"reputation"];
            NSNumber * rep2=[b objectForKey:@"reputation"];
            NSString * r1=[a objectForKey:@"registertime"];
            NSString * r2=[b objectForKey:@"registertime"];
            NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date1= [formatter dateFromString:r1];
            NSDate *date2 = [formatter dateFromString:r2];
            NSComparisonResult  result = [date1 compare:date2];
    if (result == NSOrderedDescending&&rep1==rep2) {
        return (NSComparisonResult)NSOrderedAscending;
    } else if ( result == NSOrderedAscending&&rep1==rep2) {
        return (NSComparisonResult)NSOrderedDescending;
    } else {
        return (NSComparisonResult)NSOrderedSame;
    }
      }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.rankList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* CellIdentifier =[NSString stringWithFormat:@"%@%ld", @"RankingTableViewCell",(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil != cell){
        return cell;
    }
    cell = [[[NSBundle mainBundle] loadNibNamed:@"RankingTableViewCell" owner:self options:nil] lastObject];
    cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    ((RankingTableViewCell *)cell).username.text=[self.rankList objectAtIndex:indexPath.row][@"username"];
    ((RankingTableViewCell *)cell).reputation.text=[self.rankList objectAtIndex:indexPath.row][@"reputation"];
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
    
    int ny=[nowyear integerValue];//current year
    int nm=[nowmonth integerValue];//current month
    int nd=[nowday integerValue];//current day
    
    NSString * registertime=[self.rankList objectAtIndex:indexPath.row][@"registertime"];
    NSArray * arrregistertime=[registertime componentsSeparatedByString:@"-"];
    NSString * year=arrregistertime[0];
    NSString * month=arrregistertime[1];
    NSString * day=arrregistertime[2];
    int ny1=[year integerValue];
    int nm1=[month integerValue];
    int nd1=[day integerValue];
    int total=0;
    if (ny>ny1&&nm>nm1) {
        total=12*(ny-ny1);
        int mm=nm-nm1;
        total=total+mm;
    }
    
    else if (ny>ny1&&nm<=nm1){
        total=12*(ny-ny1-1);
        int first=12-nm1;
        total=total+first+nm;
    }
    
    else{
        total=nm-nm1;
    }
    ((RankingTableViewCell *)cell).registerage.text=[NSString stringWithFormat:@"%d months",total];
    NSString * portraitstring=[self.rankList objectAtIndex:indexPath.row][@"portrait"];
    NSString *portraitImageURL = [NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/uploads/%@.png",portraitstring];
    NSData *portraitimageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:portraitImageURL]];
    
    CGSize size=CGSizeMake(36, 36);//set the width and height
    UIImage * resizedImage= [self resizeImage:[UIImage imageWithData:portraitimageData] imageSize:size];
    ((RankingTableViewCell *)cell).headIcon.image=resizedImage;
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
    CGFloat height = 80;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    PersonalViewController * personal=[[PersonalViewController alloc]initWithNibName:@"PersonalViewController" bundle:nil];
    NSString * uid=[self.rankList objectAtIndex:indexPath.row][@"userid"];
    personal.uid=uid;
    [self presentViewController:personal animated:YES completion:nil];
    
}
//

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
