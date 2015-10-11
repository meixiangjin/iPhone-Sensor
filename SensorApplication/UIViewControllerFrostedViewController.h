//
//  UIViewControllerFrostedViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/18/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FrostedViewController;
@interface UIViewController (FrostedViewController)
@property (strong, readonly, nonatomic) FrostedViewController *frostedViewController;

- (void)re_displayController:(UIViewController *)controller frame:(CGRect)frame;
- (void)re_hideController:(UIViewController *)controller;

@end
