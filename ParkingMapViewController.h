//
//  ParkingMapViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 2/1/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "CustomInfoWindow.h"
#import "SMCalloutView.h"
#import "ParkingMapTableViewCell.h"
@interface ParkingMapViewController : UIViewController<GMSMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSString * name;
@property (strong, nonatomic) IBOutlet GMSMapView *mapView_;
@property (strong,nonatomic) NSMutableArray * TotalList;
@property (strong,nonatomic) NSMutableArray * oneTotalList;
@property (strong,nonatomic)NSString * lat;
@property(strong,nonatomic)NSString * lon;
//@property (strong, nonatomic) SMCalloutView *calloutView;
@property (strong, nonatomic) UIView *emptyCalloutView;
@end
