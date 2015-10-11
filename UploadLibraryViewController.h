//
//  UploadLibraryViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FXRecordArcView.h"
#import "DLRadioButton.h"
@interface UploadLibraryViewController : UIViewController<CLLocationManagerDelegate,FXRecordArcViewDelegate,UITextFieldDelegate>
@property(nonatomic, strong) FXRecordArcView *recordView;
@property (strong, nonatomic) NSString *uid;
@property(nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic) float noiseLevel;

@end