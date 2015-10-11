//
//  ViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/18/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

{
    NSMutableData *recievedData;
    NSMutableData *webData;
    NSURLConnection *connection;
    NSMutableArray *array;
    NSMutableString *first;
    NSString *password;
    
}
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *login;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.password.secureTextEntry = YES;
    
    UIColor *color = [UIColor whiteColor];
    self.name.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    self.password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.name.text=@"";
    self.password.text=@"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(IBAction)Login:(id)sender{
    NSString *name=self.name.text;
    password=self.password.text;
    password=md5(password);
    if (name.length==0 || password==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message!" message:@"please enter 2 fields " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        webData=[NSMutableData data];
        NSString *post = [NSString stringWithFormat:@"username=%@&password=%@",name,password];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/verify.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        NSError *requestError2 = [[NSError alloc] init];
        NSHTTPURLResponse *response2 = nil;
        NSData * urlData5 = [NSURLConnection sendSynchronousRequest:request
                                                  returningResponse:&response2
                                                              error:&requestError2];
        
        NSString * thereisthisuser=@"no";
        if (urlData5!=nil) {
            NSArray *receivedUrlArr1 = [[NSMutableArray alloc]init];
            receivedUrlArr1=[[NSJSONSerialization JSONObjectWithData:urlData5 options:NSJSONReadingAllowFragments error:nil] mutableCopy];
            NSString * panduan=@"no";
            for (int i=0; i<receivedUrlArr1.count; i++) {
                NSDictionary * itemDic1=receivedUrlArr1[i];
                NSString * u=itemDic1[@"username"];
                NSString * p=itemDic1[@"password"];
                NSLog(@"the &&&&&&&&&&&&&& is %@",itemDic1[@"sessionid"]);
                if ([u isEqualToString:self.name.text] && [p isEqualToString:password]) {
                    self.uid=itemDic1[@"id"];
                    panduan=@"yes";
                }
                if ([u isEqualToString:self.name.text]) {
                    thereisthisuser=@"yes";
                }
            }
            if ([thereisthisuser isEqualToString:@"no"]){
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Try Again" message:@"The user does not exist" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else if ([panduan isEqualToString:@"yes"]) {
                
                //store this session to the database
                
                //store this session to the database
                
                
                
                UIStoryboard *str = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                TabBarViewController *main = [str instantiateViewControllerWithIdentifier:@"TabBar"];
                main.uid=self.uid;
                RootViewController *rr = (RootViewController *) [main.viewControllers objectAtIndex:0];
                ParkingViewController * pp= (ParkingViewController *)[[main. viewControllers objectAtIndex:1] topViewController ];
                LibraryViewController * ll= (LibraryViewController *)[[main.viewControllers objectAtIndex:2] topViewController];
                rr.uid=self.uid;
                pp.uid=self.uid;
                ll.uid=self.uid;
                [self presentViewController:main animated:YES completion:nil];
            }
            
            else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Try Again" message:@"Name and password doesn't match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Try Again" message:@"Please Connect to the Internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
    
}
-(IBAction)join1:(id)sender{
    NSString *urlStr=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/testconnection.php"];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *theConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    NSError *requestError2 = [[NSError alloc] init];
    NSHTTPURLResponse *response2 = nil;
    NSData * urlData5 = [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:&response2
                                                          error:&requestError2];
    
    
    if (urlData5!=nil) {
    RegisterViewController *reg=[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
    reg.delegate=self;
    [self presentViewController:reg animated:YES completion:nil];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Try Again" message:@"Please Connect to the Internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}
NSString *md5(NSString *str) {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}

-(IBAction)textFiledReturnEditing:(id)sender{
    [sender resignFirstResponder];
}


//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Try Again" message:@"Please Connect to the Internet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
