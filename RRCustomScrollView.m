//
//  RRCustomScrollView.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "RRCustomScrollView.h"

@implementation RRCustomScrollView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]])
        return YES;
    return NO;
}

@end