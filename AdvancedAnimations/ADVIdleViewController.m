//
//  ADVIdleViewController.m
//  AdvancedAnimations
//
//  Created by Marcin Pędzimąż on 27.12.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

#import "ADVIdleViewController.h"
#import "ADVArcRotationView.h"

NSString * const kADVAnimationKey = @"rotationAnimation";
NSString * const kADVImpulseAnimationGroupKey = @"impulseAnimationGroup";

const CGFloat kADVMinimumAnimationDuration = 2.0f;
const NSUInteger kADVMaximumAnimationRepeatCount = 5;
const CGFloat kADVDefaultAnimationDuration = 0.3f;

@interface ADVIdleViewController ()

@property (strong, nonatomic) IBOutletCollection(ADVArcRotationView) NSArray *arcViews;
@property (weak, nonatomic) IBOutlet ADVArcRotationView *impulseView;

@end

@implementation ADVIdleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupImpulseViewAnimation];
    [self setupArcsRoationAnimations];
}

- (void)setIdleMenuHidden:(BOOL)hidden
{
    [self removeAllAnimations];
    
    CGFloat delay = 0.1f;
    
    for (UIView *view in self.arcViews) {
        
        [UIView animateWithDuration:kADVDefaultAnimationDuration
                              delay:delay
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             view.alpha = !hidden;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
        delay += 0.1f;
    }
}

- (void)setupImpulseViewAnimation
{
    __weak __typeof__(self) weakSelf = self;
    
    self.impulseView.alpha = 0.0f;
    self.impulseView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    
    [UIView animateWithDuration:0.7
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         weakSelf.impulseView.alpha = 1.0;
                         weakSelf.impulseView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.3
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              
                                              weakSelf.impulseView.alpha = 0.0f;
                                              weakSelf.impulseView.transform = CGAffineTransformMakeScale(1.0, 1.0);

                                          } completion:^(BOOL finished) {
                                              
                                              [weakSelf setupImpulseViewAnimation];
                                          }];
                     }];
    
}

- (void)setupArcsRoationAnimations
{
    for (NSUInteger i = 0; i<self.arcViews.count; i++) {
        
        UIView *v = self.arcViews[i];
        
        CAKeyframeAnimation *anim = [self generateLayerAnimationWithDuration: (arc4random() % 5) + kADVMinimumAnimationDuration
                                                                     reverse: ((i == 3 || i == 5))];
        
        [v.layer addAnimation:anim
                       forKey:kADVAnimationKey];
    }
}

- (void)removeAllAnimations
{    
    [self.view.layer removeAllAnimations];
}

-(CAKeyframeAnimation *)generateLayerAnimationWithDuration:(CGFloat)duration
                                                   reverse:(BOOL)reverse
{
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    
    NSArray *rotationValues = reverse ? @[@(2.0f * M_PI), @0.0f] : @[@0.0f, @(2.0f * M_PI)];
    
    [rotationAnimation setValues:rotationValues];
    
    rotationAnimation.repeatCount = arc4random() % kADVMaximumAnimationRepeatCount;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.duration = duration;
    rotationAnimation.delegate = self;
    
    return rotationAnimation;
}

- (void)animationDidStop:(CAAnimation *)anim
                finished:(BOOL)flag
{
    for (UIView *v in self.arcViews) {

        CAAnimation *current = [v.layer animationForKey:kADVAnimationKey];

        if (current == anim) {
            
            [v.layer removeAnimationForKey:kADVAnimationKey];
            
            CAKeyframeAnimation *anim = [self generateLayerAnimationWithDuration: (arc4random() % 5) + kADVMinimumAnimationDuration
                                                                         reverse: (arc4random() % 2) ];
            
            [v.layer addAnimation:anim
                           forKey:kADVAnimationKey];
            
            break;
        }
    }
}

@end
