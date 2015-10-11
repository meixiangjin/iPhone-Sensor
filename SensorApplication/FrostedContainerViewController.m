//
//  FrostedContainerViewController.m
//  SensorApplication
//
//  Created by Meixiang Jin on 1/18/15.
//  Copyright (c) 2015 Meixiang Jin. All rights reserved.
//

#import "FrostedContainerViewController.h"
#import "UIImageFrostedViewController.h"
#import "UIViewFrostedViewController.h"
#import "UIViewControllerFrostedViewController.h"
#import "FrostedViewController.h"
#import "CommonFunctions.h"

@interface FrostedContainerViewController ()
@property (strong, readwrite, nonatomic) UIImageView *backgroundImageView;
@property (strong, readwrite, nonatomic) NSMutableArray *backgroundViews;
@property (strong, readwrite, nonatomic) UIView *containerView;
@property (assign, readwrite, nonatomic) CGPoint containerOrigin;
@end

@interface FrostedViewController ()

@property (assign, readwrite, nonatomic) BOOL visible;
@property (assign, readwrite, nonatomic) CGSize calculatedMenuViewSize;

@end

@implementation FrostedContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backgroundViews = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectNull];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.0f;
        [self.view addSubview:backgroundView];
        [self.backgroundViews addObject:backgroundView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
        [backgroundView addGestureRecognizer:tapRecognizer];
    }
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, self.view.frame.size.height)];
    self.containerView.clipsToBounds = YES;
    [self.view addSubview:self.containerView];
    
    if (self.frostedViewController.liveBlur) {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.view.bounds];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        toolbar.barStyle = (UIBarStyle)self.frostedViewController.liveBlurBackgroundStyle;
        [self.containerView addSubview:toolbar];
    } else {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.containerView addSubview:self.backgroundImageView];
    }
    
    if (self.frostedViewController.menuViewController) {
        [self addChildViewController:self.frostedViewController.menuViewController];
        self.frostedViewController.menuViewController.view.frame = self.containerView.bounds;
        [self.containerView addSubview:self.frostedViewController.menuViewController.view];
        [self.frostedViewController.menuViewController didMoveToParentViewController:self];
    }
    
    [self.view addGestureRecognizer:self.frostedViewController.panGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.frostedViewController.visible) {
        self.backgroundImageView.image = self.screenshotImage;
        self.backgroundImageView.frame = self.view.bounds;
        self.frostedViewController.menuViewController.view.frame = self.containerView.bounds;
        
        if (self.frostedViewController.direction == FrostedViewControllerDirectionLeft) {
            [self setContainerFrame:CGRectMake(- self.frostedViewController.calculatedMenuViewSize.width, 0, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
        }
        
        if (self.frostedViewController.direction == FrostedViewControllerDirectionRight) {
            [self setContainerFrame:CGRectMake(self.view.frame.size.width, 0, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
        }
        
        if (self.frostedViewController.direction == FrostedViewControllerDirectionTop) {
            [self setContainerFrame:CGRectMake(0, -self.frostedViewController.calculatedMenuViewSize.height, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
        }
        
        if (self.frostedViewController.direction == FrostedViewControllerDirectionBottom) {
            [self setContainerFrame:CGRectMake(0, self.view.frame.size.height, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
        }
        
        if (self.animateApperance)
            [self show];
    }
}

- (void)setContainerFrame:(CGRect)frame
{
    UIView *leftBackgroundView = self.backgroundViews[0];
    UIView *topBackgroundView = self.backgroundViews[1];
    UIView *bottomBackgroundView = self.backgroundViews[2];
    UIView *rightBackgroundView = self.backgroundViews[3];
    
    leftBackgroundView.frame = CGRectMake(0, 0, frame.origin.x, self.view.frame.size.height);
    rightBackgroundView.frame = CGRectMake(frame.size.width + frame.origin.x, 0, self.view.frame.size.width - frame.size.width - frame.origin.x, self.view.frame.size.height);
    
    topBackgroundView.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.origin.y);
    bottomBackgroundView.frame = CGRectMake(frame.origin.x, frame.size.height + frame.origin.y, frame.size.width, self.view.frame.size.height);
    
    self.containerView.frame = frame;
    self.backgroundImageView.frame = CGRectMake(- frame.origin.x, - frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)setBackgroundViewsAlpha:(CGFloat)alpha
{
    for (UIView *view in self.backgroundViews) {
        view.alpha = alpha;
    }
}

- (void)resizeToSize:(CGSize)size
{
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionLeft) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(0, 0, size.width, size.height)];
            [self setBackgroundViewsAlpha:self.frostedViewController.backgroundFadeAmount];
        } completion:nil];
    }
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionRight) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(self.view.frame.size.width - size.width, 0, size.width, size.height)];
            [self setBackgroundViewsAlpha:self.frostedViewController.backgroundFadeAmount];
        } completion:nil];
    }
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionTop) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(0, 0, size.width, size.height)];
            [self setBackgroundViewsAlpha:self.frostedViewController.backgroundFadeAmount];
        } completion:nil];
    }
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionBottom) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(0, self.view.frame.size.height - size.height, size.width, size.height)];
            [self setBackgroundViewsAlpha:self.frostedViewController.backgroundFadeAmount];
        } completion:nil];
    }
}

- (void)show
{
    void (^completionHandler)(BOOL finished) = ^(BOOL finished) {
        if ([self.frostedViewController.delegate conformsToProtocol:@protocol(FrostedViewControllerDelegate)] && [self.frostedViewController.delegate respondsToSelector:@selector(frostedViewController:didShowMenuViewController:)]) {
            [self.frostedViewController.delegate frostedViewController:self.frostedViewController didShowMenuViewController:self.frostedViewController.menuViewController];
        }
    };
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionLeft) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(0, 0, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
            [self setBackgroundViewsAlpha:self.frostedViewController.backgroundFadeAmount];
        } completion:completionHandler];
    }
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionRight) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(self.view.frame.size.width - self.frostedViewController.calculatedMenuViewSize.width, 0, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
            [self setBackgroundViewsAlpha:self.frostedViewController.backgroundFadeAmount];
        } completion:completionHandler];
    }
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionTop) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(0, 0, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
            [self setBackgroundViewsAlpha:self.frostedViewController.backgroundFadeAmount];
        } completion:completionHandler];
    }
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionBottom) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(0, self.view.frame.size.height - self.frostedViewController.calculatedMenuViewSize.height, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
            [self setBackgroundViewsAlpha:self.frostedViewController.backgroundFadeAmount];
        } completion:completionHandler];
    }
}


- (void)hide
{
    [self hideWithCompletionHandler:nil];
}

- (void)hideWithCompletionHandler:(void(^)(void))completionHandler
{
    void (^completionHandlerBlock)(void) = ^{
        if ([self.frostedViewController.delegate conformsToProtocol:@protocol(FrostedViewControllerDelegate)] && [self.frostedViewController.delegate respondsToSelector:@selector(frostedViewController:didHideMenuViewController:)]) {
            [self.frostedViewController.delegate frostedViewController:self.frostedViewController didHideMenuViewController:self.frostedViewController.menuViewController];
        }
        if (completionHandler)
            completionHandler();
    };
    
    if ([self.frostedViewController.delegate conformsToProtocol:@protocol(FrostedViewControllerDelegate)] && [self.frostedViewController.delegate respondsToSelector:@selector(frostedViewController:willHideMenuViewController:)]) {
        [self.frostedViewController.delegate frostedViewController:self.frostedViewController willHideMenuViewController:self.frostedViewController.menuViewController];
    }
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionLeft) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(- self.frostedViewController.calculatedMenuViewSize.width, 0, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
            [self setBackgroundViewsAlpha:0];
        } completion:^(BOOL finished) {
            self.frostedViewController.visible = NO;
            [self.frostedViewController re_hideController:self];
            completionHandlerBlock();
        }];
    }
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionRight) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(self.view.frame.size.width, 0, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
            [self setBackgroundViewsAlpha:0];
        } completion:^(BOOL finished) {
            self.frostedViewController.visible = NO;
            [self.frostedViewController re_hideController:self];
            completionHandlerBlock();
        }];
    }
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionTop) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(0, -self.frostedViewController.calculatedMenuViewSize.height, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
            [self setBackgroundViewsAlpha:0];
        } completion:^(BOOL finished) {
            self.frostedViewController.visible = NO;
            [self.frostedViewController re_hideController:self];
            completionHandlerBlock();
        }];
    }
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionBottom) {
        [UIView animateWithDuration:self.frostedViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(0, self.view.frame.size.height, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
            [self setBackgroundViewsAlpha:0];
        } completion:^(BOOL finished) {
            self.frostedViewController.visible = NO;
            [self.frostedViewController re_hideController:self];
            completionHandlerBlock();
        }];
    }
}

- (void)refreshBackgroundImage
{
    self.backgroundImageView.image = self.screenshotImage;
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer
{
    [self hide];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    if ([self.frostedViewController.delegate conformsToProtocol:@protocol(FrostedViewControllerDelegate)] && [self.frostedViewController.delegate respondsToSelector:@selector(frostedViewController:didRecognizePanGesture:)])
        [self.frostedViewController.delegate frostedViewController:self.frostedViewController didRecognizePanGesture:recognizer];
    
    if (!self.frostedViewController.panGestureEnabled)
        return;
    
    CGPoint point = [recognizer translationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.containerOrigin = self.containerView.frame.origin;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGRect frame = self.containerView.frame;
        if (self.frostedViewController.direction == FrostedViewControllerDirectionLeft) {
            frame.origin.x = self.containerOrigin.x + point.x;
            if (frame.origin.x > 0) {
                frame.origin.x = 0;
                
                if (!self.frostedViewController.limitMenuViewSize) {
                    frame.size.width = self.frostedViewController.calculatedMenuViewSize.width + self.containerOrigin.x + point.x;
                    if (frame.size.width > self.view.frame.size.width)
                        frame.size.width = self.view.frame.size.width;
                }
            }
        }
        
        if (self.frostedViewController.direction == FrostedViewControllerDirectionRight) {
            frame.origin.x = self.containerOrigin.x + point.x;
            if (frame.origin.x < self.view.frame.size.width - self.frostedViewController.calculatedMenuViewSize.width) {
                frame.origin.x = self.view.frame.size.width - self.frostedViewController.calculatedMenuViewSize.width;
                
                if (!self.frostedViewController.limitMenuViewSize) {
                    frame.origin.x = self.containerOrigin.x + point.x;
                    if (frame.origin.x < 0)
                        frame.origin.x = 0;
                    frame.size.width = self.view.frame.size.width - frame.origin.x;
                }
            }
        }
        
        if (self.frostedViewController.direction == FrostedViewControllerDirectionTop) {
            frame.origin.y = self.containerOrigin.y + point.y;
            if (frame.origin.y > 0) {
                frame.origin.y = 0;
                
                if (!self.frostedViewController.limitMenuViewSize) {
                    frame.size.height = self.frostedViewController.calculatedMenuViewSize.height + self.containerOrigin.y + point.y;
                    if (frame.size.height > self.view.frame.size.height)
                        frame.size.height = self.view.frame.size.height;
                }
            }
        }
        
        if (self.frostedViewController.direction == FrostedViewControllerDirectionBottom) {
            frame.origin.y = self.containerOrigin.y + point.y;
            if (frame.origin.y < self.view.frame.size.height - self.frostedViewController.calculatedMenuViewSize.height) {
                frame.origin.y = self.view.frame.size.height - self.frostedViewController.calculatedMenuViewSize.height;
                
                if (!self.frostedViewController.limitMenuViewSize) {
                    frame.origin.y = self.containerOrigin.y + point.y;
                    if (frame.origin.y < 0)
                        frame.origin.y = 0;
                    frame.size.height = self.view.frame.size.height - frame.origin.y;
                }
            }
        }
        
        [self setContainerFrame:frame];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (self.frostedViewController.direction == FrostedViewControllerDirectionLeft) {
            if ([recognizer velocityInView:self.view].x < 0) {
                [self hide];
            } else {
                [self show];
            }
        }
        
        if (self.frostedViewController.direction == FrostedViewControllerDirectionRight) {
            if ([recognizer velocityInView:self.view].x < 0) {
                [self show];
            } else {
                [self hide];
            }
        }
        
        if (self.frostedViewController.direction == FrostedViewControllerDirectionTop) {
            if ([recognizer velocityInView:self.view].y < 0) {
                [self hide];
            } else {
                [self show];
            }
        }
        
        if (self.frostedViewController.direction == FrostedViewControllerDirectionBottom) {
            if ([recognizer velocityInView:self.view].y < 0) {
                [self show];
            } else {
                [self hide];
            }
        }
    }
}

- (void)fixLayoutWithDuration:(NSTimeInterval)duration
{
    if (self.frostedViewController.direction == FrostedViewControllerDirectionLeft) {
        [self setContainerFrame:CGRectMake(0, 0, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
        [self setBackgroundViewsAlpha:self.frostedViewController.backgroundFadeAmount];
    }
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionRight) {
        [self setContainerFrame:CGRectMake(self.view.frame.size.width - self.frostedViewController.calculatedMenuViewSize.width, 0, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
        [self setBackgroundViewsAlpha:self.frostedViewController.backgroundFadeAmount];
    }
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionTop) {
        [self setContainerFrame:CGRectMake(0, 0, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
        [self setBackgroundViewsAlpha:self.frostedViewController.backgroundFadeAmount];
    }
    
    if (self.frostedViewController.direction == FrostedViewControllerDirectionBottom) {
        [self setContainerFrame:CGRectMake(0, self.view.frame.size.height - self.frostedViewController.calculatedMenuViewSize.height, self.frostedViewController.calculatedMenuViewSize.width, self.frostedViewController.calculatedMenuViewSize.height)];
        [self setBackgroundViewsAlpha:self.frostedViewController.backgroundFadeAmount];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self fixLayoutWithDuration:duration];
}

@end

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

