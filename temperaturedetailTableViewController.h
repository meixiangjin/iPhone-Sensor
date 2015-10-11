//
//  temperaturedetailTableViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BLEDevice.h"
#import "BLEUtility.h"
#import "deviceCellTemplate.h"
#import "Sensors.h"
#import <MessageUI/MessageUI.h>
#import "UploadParkingViewController.h"
//#import "ParkingViewController.h"

#define MIN_ALPHA_FADE 0.2f
#define ALPHA_FADE_STEP 0.05f


@interface temperaturedetailTableViewController : UITableViewController <CBCentralManagerDelegate,CBPeripheralDelegate,MFMailComposeViewControllerDelegate>
@property (strong,nonatomic) BLEDevice *d;
@property NSMutableArray *sensorsEnabled;
@property (strong,nonatomic) temperatureCellTemplate *ambientTemp;
@property (strong,nonatomic) temperatureCellTemplate *irTemp;
@property (strong,nonatomic) accelerometerCellTemplate *acc;
@property (strong,nonatomic) temperatureCellTemplate *rH;
@property (strong,nonatomic) accelerometerCellTemplate *mag;
@property (strong,nonatomic) sensorMAG3110 *magSensor;
@property (strong,nonatomic) temperatureCellTemplate *baro;
@property (strong,nonatomic) sensorC953A *baroSensor;
@property (strong,nonatomic) accelerometerCellTemplate *gyro;
@property (strong,nonatomic) sensorIMU3000 *gyroSensor;
@property (strong,nonatomic) sensorTagValues *currentVal;
@property (strong,nonatomic) NSMutableArray *vals;
@property (strong,nonatomic) NSTimer *logTimer;
@property(retain,nonatomic)NSString * uid;
@property float logInterval;
-(id) initWithStyle:(UITableViewStyle)style andSensorTag:(BLEDevice *)andSensorTag;
-(void) configureSensorTag;
-(void) deconfigureSensorTag;
- (IBAction) handleCalibrateMag;
- (IBAction) handleCalibrateGyro;
-(void) alphaFader:(NSTimer *)timer;
-(void) logValues:(NSTimer *)timer;
-(IBAction)sendMail:(id)sender;


@end
