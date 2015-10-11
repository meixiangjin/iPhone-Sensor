//
//  TemperatureSensorTableViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "blue.h"
#import "BLEDevice.h"
#import "temperaturedetailTableViewController.h"
#import "TemperatureNavigationViewController.h"
#import "UploadParkingViewController.h"
@interface TemperatureSensorTableViewController : UITableViewController<CBCentralManagerDelegate,CBPeripheralDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) CBCentralManager *m;
@property (strong,nonatomic) NSMutableArray *nDevices;
@property (strong,nonatomic) NSMutableArray *sensorTags;
-(NSMutableDictionary *) makeSensorTagConfiguration;
@property(strong,nonatomic)NSString * uid;
@end
