//
//  NavigationViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/18/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrostedViewController.h"
@interface NavigationViewController : UINavigationController
- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender;
@property(strong,nonatomic)NSString * uid;
@end
