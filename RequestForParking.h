//
//  RequestForParking.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestForParking : NSObject
- (void)setDirectionsQuery:(NSDictionary *)object withSelector:(SEL)selector
              withDelegate:(id)delegate;
- (void)setDirectionsQuery1:(NSDictionary *)object withSelector:(SEL)selector
              withDelegate:(id)delegate;
- (void)retrieveDirections:(SEL)sel withDelegate:(id)delegate;
- (void)fetchedData:(NSData *)data withSelector:(SEL)selector
       withDelegate:(id)delegate;
@property(strong,nonatomic)NSString * selfslatitude;
@property(strong,nonatomic)NSString * selfslongitude;
@property(strong,nonatomic)NSString * type;
@end
