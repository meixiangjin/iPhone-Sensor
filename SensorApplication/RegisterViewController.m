//
//  RegisterViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/18/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "RegisterViewController.h"
#import "HomeViewController.h"
#import "TextFieldValidator.h"
#import "DLRadioButton.h"

#define REGEX_USER_NAME_LIMIT @"^.{3,10}$"
#define REGEX_USER_NAME @"[A-Za-z0-9]{3,10}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD_LIMIT @"^.{6,20}$"
#define REGEX_PASSWORD @"[A-Za-z0-9]{6,20}"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"

@interface RegisterViewController ()
@property (strong, nonatomic) IBOutlet TextFieldValidator *username;
@property (strong, nonatomic) IBOutlet TextFieldValidator *password;
@property (strong, nonatomic) IBOutlet TextFieldValidator *email;
@property (strong, nonatomic) IBOutlet UITextField *birth;

@property (strong, nonatomic) IBOutlet UITextField *sign;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic) NSArray *buttomRadioButtons;
@property (nonatomic) NSString * gender;

@property (strong, nonatomic) IBOutlet TextFieldValidator *confirmPass;
@end

@implementation RegisterViewController
NSString *currentDate;
static NSString* __placeholderText = @"MM/DD/YYYY";
static NSCharacterSet* __nonNumbersSet;
- (void)viewDidLoad {
    [super viewDidLoad];
     [self.birth setDelegate:self];
    [self setupAlerts];
    self.password.secureTextEntry = YES;
    self.confirmPass.secureTextEntry=YES;
    self.username.text=@"";
    self.password.text=@"";
    self.email.text=@"";
    self.birth.text=@"";
    self.sign.text=@"";
    self.confirmPass.text=@"";
    self.image.image=NULL;
    
    UINavigationBar *myBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:myBar];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem=leftButton;
    [myBar pushNavigationItem:self.navigationItem animated:YES];
    
    DLRadioButton *firstRadioButton = [[DLRadioButton alloc] initWithFrame:CGRectMake(25, 290, 200, 25)];
    firstRadioButton.buttonSideLength = 20;
    [firstRadioButton setTitle:@"Female" forState:UIControlStateNormal];
    [firstRadioButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    firstRadioButton.circleColor = [UIColor blackColor];
    firstRadioButton.indicatorColor = [UIColor blackColor];
    firstRadioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:firstRadioButton];
    NSMutableArray * otherButtons=[NSMutableArray new];
    
    DLRadioButton *firstRadioButton2 = [[DLRadioButton alloc] initWithFrame:CGRectMake(150, 290, 200, 25)];
    firstRadioButton2.buttonSideLength = 20;
    [firstRadioButton2 setTitle:@"Male" forState:UIControlStateNormal];
    [firstRadioButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    firstRadioButton2.circleColor = [UIColor blackColor];
    firstRadioButton2.indicatorColor = [UIColor blackColor];
    firstRadioButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:firstRadioButton2];
    [otherButtons addObject:firstRadioButton2];
    firstRadioButton.otherButtons=otherButtons;
    self.buttomRadioButtons=[@[firstRadioButton] arrayByAddingObjectsFromArray:otherButtons];

    // Do any additional setup after loading the view from its nib.
}
-(void)Back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setupAlerts{
    [self.username addRegx:REGEX_USER_NAME_LIMIT withMsg:@"Username must be 3-10 characters in length"];
    [self.username addRegx:REGEX_USER_NAME withMsg:@"Only alpha numeric characters are allowed."];
    self.username.validateOnResign=NO;
    
    [self.email addRegx:REGEX_EMAIL withMsg:@"Enter valid email."];
    
    [self.password addRegx:REGEX_PASSWORD_LIMIT withMsg:@"Password must be 6-20 characters in length"];
    [self.password addRegx:REGEX_PASSWORD withMsg:@"Password must contain alpha numeric characters."];
    
    [self.confirmPass addConfirmValidationTo:self.password withMsg:@"Passwords do not match"];
    
//    [txtPhone addRegx:REGEX_PHONE_DEFAULT withMsg:@"Phone number must be in proper format (eg. ###-###-####)"];
//    txtPhone.isMandatory=NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signup:(id)sender {
   
    NSLog(@"the user gender is %@",self.sgender);
    self.suser=self.username.text;
    self.spass=self.password.text;
    NSString * respond=[self ValidateUsernameSame:self.suser];
    if ([respond isEqualToString:@"YES"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Username already exists Please enter different username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([self.username.text isEqualToString:@""]||[self.password.text isEqualToString:@""]||[self.confirmPass.text isEqualToString:@""]||[self.email.text isEqualToString:@""]||[self.birth.text isEqualToString:@""]||[(DLRadioButton *)self.buttomRadioButtons[0] selectedButton].titleLabel.text.length<=0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please input the required field" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    else if (self.image.image==nil){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Must have profile image" message:@"Please choose or take a photo " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
    if([self.username validate] & [self.password validate] & [self.email validate] & [self.email validate] ){
    self.spass=mdd5(self.spass);
        NSDateFormatter *df=[[NSDateFormatter alloc]init];
        NSLocale *usLocale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [df setLocale:usLocale];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [df setTimeZone:timeZone];
        df.dateFormat=@"yyyy-MM-dd";
        NSDate *date=[NSDate date];
        currentDate=[df stringFromDate:date];
    self.semail=self.email.text;
    self.sbirth=self.birth.text;
    self.sgender=[(DLRadioButton *)self.buttomRadioButtons[0] selectedButton].titleLabel.text;
    self.simage=self.image.image;
        if (self.sign.text==nil||[self.sign.text isEqualToString:@""]) {
            self.ssign=@"No Introduction";
        }
        else{
             self.ssign=self.sign.text;
        }
    NSString *urlStr1=[NSString stringWithFormat:@"http://euryale.cs.uwlax.edu/user.php"];
    NSURL *url1=[NSURL URLWithString:urlStr1];
    NSMutableURLRequest *request1=[NSMutableURLRequest requestWithURL:url1];
    NSData * cc;
    cc=UIImageJPEGRepresentation(self.simage, 0.2f);
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
    NSString *postLength = [NSString stringWithFormat:@"%lu", 1];
    [request1 setValue:postLength forHTTPHeaderField:@"number"];
    NSString *postName = [NSString stringWithFormat:@"%@", totalName];
    [request1 setValue:postName forHTTPHeaderField:@"totalName"];
    [request1 addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request1 setHTTPBody:postbody];
    [request1 addValue:currentDate forHTTPHeaderField:@"registertime"];
    [request1 addValue:self.suser forHTTPHeaderField:@"username"];
    [request1 addValue:self.spass forHTTPHeaderField:@"password"];
    [request1 addValue:self.semail forHTTPHeaderField:@"email"];
    [request1 addValue:self.sbirth forHTTPHeaderField:@"birthday"];
    [request1 addValue:self.sgender forHTTPHeaderField:@"gender"];
    [request1 addValue:self.ssign forHTTPHeaderField:@"sign"];
    [request1 setHTTPMethod:@"POST"];
    NSURLConnection *theConnection1=[[NSURLConnection alloc]initWithRequest:request1 delegate:self];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    }else{
         [[[UIAlertView alloc] initWithTitle:@"Please Input Correct Information" message:NULL delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
        
    }
}
- (IBAction)takePicture:(id)sender {
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
                
            }
            else {
                NSLog(@"Album is not available.");
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Album is not available.");
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
    NSLog(@"Image Picker Controller canceled.");
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Image Picker Controller did finish picking media.");
    UIImage *imageview = info[UIImagePickerControllerOriginalImage];
    self.image.image=imageview;
    [self dismissViewControllerAnimated:YES completion:nil];
}


NSString *mdd5(NSString *str) {
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


-(IBAction)textFieldEnd:(id)sender{
    NSString * respond=[self ValidateUsernameSame:[sender text]];
    if ([respond isEqualToString:@"YES"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Username already exists Please enter different username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
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


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Make sure that the non number set is lazily initialized
    if (__nonNumbersSet == nil)
        __nonNumbersSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    NSString* preEditString = textField.text;
    __block NSInteger activeLength = 0;
    NSAttributedString* attributedString = self.birth.attributedText;
    [attributedString enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
        
        if ([value isKindOfClass:[UIColor class]])
        {
            CGFloat white;
            [((UIColor*)value) getWhite:&white alpha:nil];
            if (white != 1.0f)
                activeLength = range.location;
        }
        
    }];
    
    // If there is no pseudo placeholder text then that means it has reached the end
    if (activeLength == 0 &&
        self.birth.text.length == 10 &&
        ![self.birth.text isEqualToString:__placeholderText])
    {
        activeLength = self.birth.text.length;
    }
    
    // Perform the edits as long as the birthday text length limit hasnt been reached
    if (!(activeLength == 10 && string.length > 0))
    {
        if (string.length <= 0)
        {
            if (textField.text.length > 0)
            {
                //----
                // Determine if you need to just delete the last character or
                // the last two characterse (delete / as well)
                //----
                NSInteger deleteDelta = [[textField.text substringWithRange:NSMakeRange(activeLength-1, 1)] isEqualToString:@"/"] ? 2 : 1;
                if (activeLength <= deleteDelta)
                {
                    [self.birth setText:@""];
                    return NO;
                }
                else
                    [self.birth setText:[NSString stringWithFormat:@"%@", [self.birth.text substringToIndex:(activeLength - deleteDelta)]]];
            }
        }
        else if ([string rangeOfCharacterFromSet:__nonNumbersSet].location == NSNotFound)
        {
            // Enter here if the input was a numbe
            if (activeLength < 2)
            {
                // Check to make sure that the month field is 1-12
                NSInteger month = [[textField.text stringByAppendingString:string] integerValue];
                if (month <= 12 && month >= 0)
                {
                    if (textField.text.length == 0)
                    {
                        // Enter here to handle the first value being input
                        if ([string integerValue] > 1)
                        {
                            //----
                            // Enter here because you need to add the prefix 0 since they enetered a digit 2-9
                            // and that wont work as the first digit in a month
                            //----
                            NSLog(@"the string is %@",string);
                            [self.birth setText:[NSString stringWithFormat:@"0%@/", string]];
                        }
                       
                        else
                            [self.birth setText:[NSString stringWithFormat:@"%@", string]];
                    }
                    else
                    {
                        //-----
                        // Enter here if entering the second digit of the month
                        // Need to make sure it reacts properly based off of the first digit in the month
                        //-----
                        if (([[textField.text substringToIndex:1] isEqualToString:@"0"] || [string integerValue] <= 2)&&![string isEqualToString:@"0"])
                            [textField setText:[NSString stringWithFormat:@"%@%@/", [textField.text substringToIndex:activeLength], string]];
                    }
                }
            }
            else if (activeLength < 6)
            {
                // Handle the day aspect of the birthday input
                if (activeLength == 3)
                {
                    //----
                    // Only allow 0-3 in the first day spot
                    // Otherwise prefix it with a 0
                    //----
                    if ([string isEqualToString:@"0"] || [string isEqualToString:@"1"] ||
                        [string isEqualToString:@"2"] || [string isEqualToString:@"3"])
                    {
                        [self.birth setText:[NSString stringWithFormat:@"%@%@", [self.birth.text substringToIndex:activeLength], string]];
                    }
                    else
                    {
                        [self.birth setText:[NSString stringWithFormat:@"%@0%@/", [self.birth.text substringToIndex:activeLength], string]];
                    }
                }
                else if (activeLength == 4)
                {
                    if (![[self.birth.text substringToIndex:activeLength]isEqualToString:@"0"]&&![string isEqualToString:@"0"]) {
                          [self.birth setText:[NSString stringWithFormat:@"%@%@/", [self.birth.text substringToIndex:activeLength], string]];
                    }
                  
                }
            }
            else if (activeLength < 11)
            {
                // Handle the year aspect of the birthday input
                BOOL addText;
                if (activeLength == 6)
                {
                    // Only allow for 19XX or 2XXX dates
                    addText = ([string isEqualToString:@"1"] || [string isEqualToString:@"2"]) ? YES : NO;
                }
                else
                    addText = YES;
                
                if (addText)
                    [self.birth setText:[NSString stringWithFormat:@"%@%@", [self.birth.text substringToIndex:activeLength], string]];
            }
        }
        
        //----
        // Add whatever placeholder text is supposed to be left
        // Only set the attributed text if it was changed during the process
        //----
        if (![textField.text isEqualToString:preEditString])
        {
            NSInteger offset = textField.text.length;
            NSMutableAttributedString* pseudoPlaceholder = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", textField.text, [__placeholderText substringFromIndex:(__placeholderText.length-(__placeholderText.length-textField.text.length))]] attributes:nil];
            
            [pseudoPlaceholder addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor colorWithWhite:.7843 alpha:1.0f]
                                      range:NSMakeRange(textField.text.length, pseudoPlaceholder.string.length - textField.text.length)];
            
            [textField setAttributedText:pseudoPlaceholder];
            [textField setSelectedTextRange:[textField textRangeFromPosition:[textField positionFromPosition:textField.beginningOfDocument offset:offset] toPosition:[textField positionFromPosition:textField.beginningOfDocument offset:offset]]];
        }
    }
    
    return NO;
}


@end
