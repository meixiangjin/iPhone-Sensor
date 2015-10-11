//
//  FrostedViewController.h
//  SensorApplication
//
//  Created by Meixiang Jin on 1/18/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerFrostedViewController.h"
#import "HomeViewController.h"
typedef NS_ENUM(NSInteger, FrostedViewControllerDirection) {
    FrostedViewControllerDirectionLeft,
    FrostedViewControllerDirectionRight,
    FrostedViewControllerDirectionTop,
    FrostedViewControllerDirectionBottom
};
typedef NS_ENUM(NSInteger, FrostedViewControllerLiveBackgroundStyle) {
    FrostedViewControllerLiveBackgroundStyleLight,
    FrostedViewControllerLiveBackgroundStyleDark
};

@protocol FrostedViewControllerDelegate;

@interface FrostedViewController : UIViewController

@property (strong, readonly, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (assign, readwrite, nonatomic) BOOL panGestureEnabled;
@property (assign, readwrite, nonatomic) FrostedViewControllerDirection direction;
@property (assign, readwrite, nonatomic) CGFloat backgroundFadeAmount;
@property (strong, readwrite, nonatomic) UIColor *blurTintColor; // Used only when live blur is off
@property (assign, readwrite, nonatomic) CGFloat blurRadius; // Used only when live blur is off
@property (assign, readwrite, nonatomic) CGFloat blurSaturationDeltaFactor; // Used only when live blur is off
@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;
@property (assign, readwrite, nonatomic) BOOL limitMenuViewSize;
@property (assign, readwrite, nonatomic) CGSize menuViewSize;
@property (assign, readwrite, nonatomic) BOOL liveBlur; // iOS 7 only
@property (assign, readwrite, nonatomic) FrostedViewControllerLiveBackgroundStyle liveBlurBackgroundStyle; // iOS 7 only

@property (weak, readwrite, nonatomic) id<FrostedViewControllerDelegate> delegate;
@property (strong, readwrite, nonatomic) UIViewController *contentViewController;
@property (strong, readwrite, nonatomic) UIViewController *menuViewController;

//new thing
@property(retain,nonatomic)NSString * uid1;
//new thing

- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController;
- (void)presentMenuViewController;
- (void)hideMenuViewController;
- (void)resizeMenuViewControllerToSize:(CGSize)size;
- (void)hideMenuViewControllerWithCompletionHandler:(void(^)(void))completionHandler;
- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer;


@end

@protocol FrostedViewControllerDelegate <NSObject>
@optional
- (void)frostedViewController:(FrostedViewController *)frostedViewController willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)frostedViewController:(FrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)frostedViewController:(FrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController;
- (void)frostedViewController:(FrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController;
- (void)frostedViewController:(FrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController;
- (void)frostedViewController:(FrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController;

@end