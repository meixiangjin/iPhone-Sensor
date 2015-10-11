//
//  LibraryMapTotalViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 2/1/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "RequestForParking.h"
#import "MDDirectionService.h"
#import "SMCalloutView.h"
#import "LibraryMapViewController.h"
@interface LibraryMapTotalViewController : UIViewController<GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet GMSMapView *mapView_;
@property (strong, nonatomic) SMCalloutView *calloutView;
@property (strong, nonatomic) UIView *emptyCalloutView;
@property (strong,nonatomic) NSMutableArray * TotalList;
@end
