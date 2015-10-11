//
//  SecondViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/18/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

-(IBAction)showMenu:(id)sender{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}
@end
