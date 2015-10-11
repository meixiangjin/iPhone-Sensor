//
//  RRMessageModel.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRMessageModel : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSMutableArray *photos;

@end