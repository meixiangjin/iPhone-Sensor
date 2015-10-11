//
//  MDDirectionService.h
//  SensorApplication
//
//  Created by Meixiang Jin on 2/1/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDDirectionService : NSObject
- (void)setDirectionsQuery:(NSDictionary *)object withSelector:(SEL)selector
              withDelegate:(id)delegate;
- (void)retrieveDirections:(SEL)sel withDelegate:(id)delegate;
- (void)fetchedData:(NSData *)data withSelector:(SEL)selector
       withDelegate:(id)delegate;
@end