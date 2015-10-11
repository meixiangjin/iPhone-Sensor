//
//  RootViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/18/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "RootViewController.h"
#import "MenuViewController.h"
#import "NavigationViewController.h"
#import "HomeViewController.h"
@interface RootViewController()

@end

@implementation RootViewController

- (void)awakeFromNib

{
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    MenuViewController *menu=(MenuViewController *)self.menuViewController;
    menu.uid=self.uid;
    NSLog(@"77777778888888 %@",menu.uid);
   NavigationViewController *nav=(NavigationViewController *)self.contentViewController;
   HomeViewController  * home=(HomeViewController *)[nav topViewController];
   home.uid=self.uid;

}
@end
