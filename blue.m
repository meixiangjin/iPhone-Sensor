//
//  blue.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "blue.h"

@implementation blue
-(instancetype)init{
    self=[super init];
    self.m1.delegate=self;
    self.m1 = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    self.nDevices = [[NSMutableArray alloc]init];
    self.sensorTags = [[NSMutableArray alloc]init];
    return self;
    
}


@end
