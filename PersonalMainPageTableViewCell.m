//
//  PersonalMainPageTableViewCell.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/19/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "PersonalMainPageTableViewCell.h"


@implementation PersonalMainPageTableViewCell


- (void)awakeFromNib {
    self.username.font=[UIFont systemFontOfSize:15];
    self.time.font=[UIFont systemFontOfSize:13];
    self.time.textColor=[UIColor grayColor];
    self.username.textColor=[UIColor orangeColor];
    self.address.textColor=[UIColor grayColor];
    self.address.font=[UIFont systemFontOfSize:15];
    self.type.font=[UIFont fontWithName:@"Arial-BoldItalicMT" size:18];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image1 = (ClickImage *)[[UIImageView alloc] initWithFrame:CGRectMake(5,147,80,80)];
        self.image2 = (ClickImage *)[[UIImageView alloc] initWithFrame:CGRectMake(93,147,80,80)];
        self.image3 = (ClickImage *)[[UIImageView alloc] initWithFrame:CGRectMake(181,147,80,80)];
        self.image1.canClick=YES;
        self.image2.canClick=YES;
        self.image3.canClick=YES;
        [self addSubview:self.image1];
        [self addSubview:self.image2];
        [self addSubview:self.image3];
        
    }
    return self;
}

- (IBAction)Like:(id)sender {
    
    self.likeButton.hidden=YES;
    
    NSString * scount=self.count.text;
    int cc=[scount floatValue];
    cc=cc+1;
    NSString * ss=[NSString stringWithFormat:@"%d",cc];
    self.count.text=ss;
    [self addToGPS];
    [self addToUser];
    [self addReputation];
    
}

-(void)addToGPS{
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/addzctogps.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    NSString *body=[NSString stringWithFormat:@"rid=%@",self.rid];
    NSMutableURLRequest *request2=[NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request2 delegate:self];
    
}
-(void)addToUser{
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/addxinyutoperson.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    NSString *body=[NSString stringWithFormat:@"uid=%@",self.uid];
    NSMutableURLRequest *request2=[NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request2 delegate:self];
}

-(void)addReputation{
    NSString *urlStr2=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/addzanconnectpeople.php"];
    NSURL *url2=[NSURL URLWithString:urlStr2];
    
    NSString *body=[NSString stringWithFormat:@"uid=%@&rid=%@",self.uid,self.rid];
    NSMutableURLRequest *request2=[NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    [request2 setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request2 delegate:self];

}
@end
