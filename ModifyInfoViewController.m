//
//  ModifyInfoViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/19/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "ModifyInfoViewController.h"
#import "TextFieldValidator.h"

#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"

@interface ModifyInfoViewController ()

@end

@implementation ModifyInfoViewController

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
UIImage * profileImage;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Me";
    [self setupAlerts];
    self.birthday.userInteractionEnabled=NO;
    self.gender.userInteractionEnabled=NO;
    
    
    UINavigationBar *myBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:myBar];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem=leftButton;
    [myBar pushNavigationItem:self.navigationItem animated:YES];
    
    
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
    
    NSString *portraitImageURL = [NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/uploads/%@.png",profileString];
    NSData *portraitimageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:portraitImageURL]];
    CGSize size=CGSizeMake(80, 80);//set the width and height
    UIImage * resizedImage= [self resizeImage:[UIImage imageWithData:portraitimageData] imageSize:size];
    
    self.username.text=username;
    self.email.text=email;
    self.birthday.text=birthday;
    self.gender.text=gender;
    self.sign.text=sign;
    self.image.image=[UIImage imageWithData:portraitimageData];
    profileImage=resizedImage;
    
}

-(void)Back{
  [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)setupAlerts{
    [self.username addRegx:REGEX_USER_NAME_LIMIT withMsg:@"User name charaters limit should be come between 3-10"];
    [self.username addRegx:REGEX_USER_NAME withMsg:@"Only alpha numeric characters are allowed."];
    self.username.validateOnResign=NO;
    
    [self.email addRegx:REGEX_EMAIL withMsg:@"Enter valid email."];
    
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)textFieldReturnEditing:(id)sender{
    [sender resignFirstResponder];
}
-(IBAction)takePicture:(id)sender{
    UIActionSheet * photoBtnActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library",@"Take Photo" ,nil];
    [photoBtnActionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [photoBtnActionSheet showInView:self.view.window];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        @try {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc] init];
                [imgPickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [imgPickerVC.navigationBar setBarStyle:UIBarStyleBlack];
                [imgPickerVC setDelegate:self];
                [imgPickerVC setAllowsEditing:NO];
                [self presentViewController:imgPickerVC animated:YES completion:nil];
            }else {
                
            }
        }
        @catch (NSException *exception) {
            
        }
    }
    if (buttonIndex == 1) {
        @try {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
                [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
                [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
                [cameraVC setDelegate:self];
                [cameraVC setAllowsEditing:NO];
                [self presentViewController:cameraVC animated:YES completion:nil];
                
            }else {
                NSLog(@"Camera is not available.");
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Camera is not available.");
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Image Picker Controller did finish picking media.");
    UIImage *imageview = info[UIImagePickerControllerOriginalImage];
    self.image.image=imageview;
    profileImage=self.image.image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)ModifyInfo:(id)sender{
    username=self.username.text;
    email=self.email.text;
    sign=self.sign.text;
    NSString *urlStr1=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/modifyInfo.php"];
    NSURL *url1=[NSURL URLWithString:urlStr1];
    NSMutableURLRequest *request1=[NSMutableURLRequest requestWithURL:url1];
    NSData * cc;
    cc=UIImageJPEGRepresentation(profileImage, 1.0f);
    NSMutableData *postbody = [NSMutableData data];
    NSString * totalName=@"";
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSData *dataImage=cc;
    NSUUID  *UUID = [NSUUID UUID];
    NSString* imageName = [UUID UUIDString];
    totalName=imageName;
    
    [postbody appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image%d\"; filename=\"%@.png\"\r\n",1,imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:dataImage]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"/////////// the total Name is %@",totalName);
    NSString *postLength = [NSString stringWithFormat:@"%lu", 1];
    [request1 setValue:postLength forHTTPHeaderField:@"number"];
    NSString *postName = [NSString stringWithFormat:@"%@", totalName];
    [request1 setValue:postName forHTTPHeaderField:@"totalName"];
    [request1 addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request1 setHTTPBody:postbody];
    [request1 addValue:username forHTTPHeaderField:@"username"];
    [request1 addValue:email forHTTPHeaderField:@"email"];
    [request1 addValue:sign forHTTPHeaderField:@"sign"];
    [request1 addValue:self.uid forHTTPHeaderField:@"id"];
    [request1 setHTTPMethod:@"POST"];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request1 delegate:self];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    return newImage;
}

-(IBAction)textFieldEnd:(id)sender{
    if (![username isEqualToString:[sender text]]) {
        NSString * respond=[self ValidateUsernameSame:[sender text]];
        if ([respond isEqualToString:@"YES"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Username is already exist" message:@"please enter different username " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
   
}
-(NSString *)ValidateUsernameSame:(NSString *)username{
    NSString *urlStr=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/checkusernamesame.php"];
    NSURL *url=[NSURL URLWithString:urlStr];
    NSString *body=[NSString stringWithFormat:@"username=%@",username];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPBody:[body dataUsingEncoding:NSASCIIStringEncoding  ]];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *theConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    NSError *requestError = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData * urlData = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&requestError];
    NSString* result = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    return result;
}
@end
