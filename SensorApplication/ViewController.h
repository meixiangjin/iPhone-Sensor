//
//  ViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/18/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
#import "HomeViewController.h"
#import "NavigationViewController.h"
#import "TabBarViewController.h"
#import "RootViewController.h"
#import "FrostedViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "ParkingViewController.h"
#import "LibraryViewController.h"
#import "TemperatureNavigationViewController.h"
@interface ViewController : UIViewController<RegisterViewControllerDelegate, NSURLConnectionDataDelegate,UITextFieldDelegate>
@property (strong,nonatomic) NSString *username;
@property(strong,nonatomic)NSString * uid;
@end
