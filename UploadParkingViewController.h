//
//  UploadParkingViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestForParking.h"
@interface UploadParkingViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutlet UILabel *temperature;
@property (strong, nonatomic) IBOutlet UILabel *humidity;
@property (strong, nonatomic) IBOutlet UITextField *parkingname;
@property (strong, nonatomic) IBOutlet UITextField *lat;
@property (strong, nonatomic) IBOutlet UITextField *lon;
@property (strong, nonatomic) IBOutlet UITextField *state;
@property (strong, nonatomic) IBOutlet UITextField *zip;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *street;
@property (strong, nonatomic) IBOutlet UITextView *note;
@property(strong,nonatomic)NSString * uid;
@property(strong,nonatomic)NSString * tem;
@property(strong,nonatomic)NSString * hum;
@property(strong,nonatomic)NSString * panduan;
@property (nonatomic) NSArray *buttomRadioButtons;
@end
