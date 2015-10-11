//
//  RegisterViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/18/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CommonCrypto/CommonDigest.h>
@class RegisterViewController;
@protocol RegisterViewControllerDelegate
-(void)registerViewControllerDidFinish:(RegisterViewController *)controller;


@end

@interface RegisterViewController : UIViewController< UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (strong,nonatomic) id <RegisterViewControllerDelegate> delegate;
@property(strong,nonatomic)NSString * suser;
@property(strong,nonatomic)NSString * spass;
@property(strong,nonatomic)NSString * semail;
@property(strong,nonatomic)NSString * sbirth;
@property(strong,nonatomic)NSString * sgender;
@property(strong,nonatomic)NSString * ssign;
@property(strong,nonatomic)UIImage * simage;

-(IBAction)textFiledReturnEditing:(id)sender;
@end
