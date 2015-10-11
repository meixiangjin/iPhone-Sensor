//
//  FrostedContainerViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/18/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FrostedViewController;

@interface FrostedContainerViewController : UIViewController
@property (strong, readwrite, nonatomic) UIImage *screenshotImage;
@property (weak, readwrite, nonatomic) FrostedViewController *frostedViewController;
@property (assign, readwrite, nonatomic) BOOL animateApperance;
@property (strong, readonly, nonatomic) UIView *containerView;

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer;
- (void)hide;
- (void)resizeToSize:(CGSize)size;
- (void)hideWithCompletionHandler:(void(^)(void))completionHandler;
- (void)refreshBackgroundImage;

@end
