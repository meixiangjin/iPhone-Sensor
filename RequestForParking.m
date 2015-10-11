//
//  RequestForParking.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "RequestForParking.h"

@implementation RequestForParking{
@private
    BOOL _sensor;
    BOOL _alternatives;
    NSURL *_directionsURL;
    NSArray *_waypoints;
    
}


static NSString *kMDDirectionsURL = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?";

- (void)setDirectionsQuery:(NSDictionary *)query withSelector:(SEL)selector
              withDelegate:(id)delegate{
    float l1=[self.selfslatitude floatValue];
    float l2=[self.selfslongitude floatValue];
    NSString *origin = [[NSString alloc] initWithFormat:@"%f,%f",l1,l2];
    NSMutableString *url =
    [NSMutableString stringWithFormat:@"%@&location=%@&radius=5000&types=%@&key=AIzaSyAt91O7jNh8kV2DSTmFHV9QzVZQyybhH5A",
     kMDDirectionsURL,origin,self.type];
    url = [url
           stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    _directionsURL = [NSURL URLWithString:url];
    [self retrieveDirections:selector withDelegate:delegate];
}
- (void)retrieveDirections:(SEL)selector withDelegate:(id)delegate{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData* data =
        [NSData dataWithContentsOfURL:_directionsURL];
        [self fetchedData:data withSelector:selector withDelegate:delegate];
    });
}

- (void)fetchedData:(NSData *)data
       withSelector:(SEL)selector
       withDelegate:(id)delegate{
    
       NSError* error;
       NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    NSLog(@"the json is %@",json);
      [delegate performSelector:selector withObject:json];
}




- (void)setDirectionsQuery1:(NSDictionary *)query withSelector:(SEL)selector
               withDelegate:(id)delegate{
    float l1=[self.selfslatitude floatValue];
    float l2=[self.selfslongitude floatValue];
    NSString *origin = [[NSString alloc] initWithFormat:@"%f,%f",l1,l2];
    NSMutableString *url =
    [NSMutableString stringWithFormat:@"%@&location=%@&radius=50&types=%@&key=AIzaSyAt91O7jNh8kV2DSTmFHV9QzVZQyybhH5A",
     kMDDirectionsURL,origin,self.type];
    url = [url
           stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    _directionsURL = [NSURL URLWithString:url];
    [self retrieveDirections:selector withDelegate:delegate];
}

@end
