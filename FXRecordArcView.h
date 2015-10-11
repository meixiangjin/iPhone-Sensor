//
//  FXRecordArcView.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define MAX_RECORD_DURATION 10.0
#define WAVE_UPDATE_FREQUENCY   0.1
#define SILENCE_VOLUME   45.0
#define SOUND_METER_COUNT  6
#define HUD_SIZE  320.0

@class FXRecordArcView;
@protocol FXRecordArcViewDelegate <NSObject>

- (void)recordArcView:(FXRecordArcView *)arcView volume:(float)recordVolume;

@end

@interface FXRecordArcView : UIView<AVAudioRecorderDelegate>
@property(weak, nonatomic) id<FXRecordArcViewDelegate> delegate;
- (void)startForFilePath:(NSString *)filePath;
- (void)commitRecording;

@end