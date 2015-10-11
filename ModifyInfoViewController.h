//
//  ModifyInfoViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/19/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "TextFieldValidator.h"
@interface ModifyInfoViewController : UIViewController<UITextFieldDelegate,UITextFieldDelegate>
@property(retain,nonatomic)NSString * uid;
@property (strong, nonatomic) IBOutlet TextFieldValidator *username;
@property (strong, nonatomic) IBOutlet TextFieldValidator *email;
@property (strong, nonatomic) IBOutlet UITextField *birthday;
@property (strong, nonatomic) IBOutlet UITextField *gender;
@property (strong, nonatomic) IBOutlet UITextField *sign;
@property (strong, nonatomic) IBOutlet UIImageView *image;
-(IBAction)textFieldReturnEditing:(id)sender;
@end
