//
//  RRSendMessageViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/24/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRMessageModel.h"
#import "UICollectionViewCellPhoto.h"

@protocol RRSendMessageDelegate;

@interface RRSendMessageViewController : UIViewController <UICollectionViewDelegate,
UICollectionViewDataSource, UITextViewDelegate>

@property (nonatomic, assign) id<RRSendMessageDelegate> delegate;

@property (nonatomic, assign) NSInteger numberPhoto;
@property (nonatomic) float noiseLevel;
@property (nonatomic) NSString * sta;
@property (nonatomic) NSString * city;
@property (nonatomic) NSString * zip;
@property (nonatomic) NSString * street;
@property (nonatomic) NSString * latitude;
@property (nonatomic) NSString * longitude;
@property (nonatomic) NSString * libraryName;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *currentstate;
- (void) presentController:(UIViewController *)parentController :(void (^)(RRMessageModel *model, BOOL isCancel))completion;

@end

@protocol RRSendMessageDelegate <NSObject>

@optional
- (void) messageCancel;
- (void) getMessage:(RRMessageModel *)message;

@end

