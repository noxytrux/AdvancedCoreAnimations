//
//  ADVRecordButton.m
//  AdvancedAnimations
//
//  Created by Marcin Pędzimąż on 28.12.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

#import "ADVRecordButton.h"
#import "UIImage+Utilities.h"
#import "UIColor+Utilities.h"

NSString * const kADVHeartBeatAnimationKey = @"heartBeatAnimation";
NSString * const kADVMaskAnimationKey = @"path";
NSString * const kADVScaleButtonKey = @"transformButton";

@implementation ADVRecordButton

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.defaultSpacing = 4.0f;
    self.textOffset = 0.0f;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    UIImage *backgrondImage = [UIImage imageWithRadius:100
                                                 color:[UIColor colorFromHexString:@"#FF2800" withAlphaComponent:0.7]];
    
    UIImage *frontImage = [UIImage imageWithRadius:70
                                             color:[UIColor colorFromHexString:@"#FF2800"]];
    
    [self setBackgroundImage:backgrondImage
                    forState:UIControlStateNormal];
    
    [self setImage:frontImage
          forState:UIControlStateNormal];
}

- (void)prepareForInterfaceBuilder
{
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize imageSize = self.imageView.frame.size;
    
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                  NSFontAttributeName : self.titleLabel.font };
    
    CGRect titleFrame = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                                           options:NSStringDrawingUsesFontLeading
                                                        attributes:attributes
                                                           context:NULL];
    CGSize titleSize = titleFrame.size;

    CGFloat totalHeight = (imageSize.height + titleSize.height + self.defaultSpacing);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height) - self.textOffset,0.0);
}

- (void)fadeOutWithScaleDown
{
    self.alpha = 0.0f;
    self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
}

- (void)animateButtonHidden:(BOOL)hidden
{
    [self.layer removeAllAnimations];
    
    if(hidden) {
        [self applyHeartBeatAnimation:NO];
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             self.transform = CGAffineTransformMakeScale(1.4, 1.4);
                             
                         } completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:0.3
                                              animations:^{
                                                  
                                                  self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
                                                  self.alpha = 0.0f;
                                                  
                                              } completion:^(BOOL finished) {
                                                  
                                              }];
                         }];
        
        return;
    }

    if (self.alpha > 0.0) {
        
        self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        self.alpha = 0.0f;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         self.transform = CGAffineTransformMakeScale(1.4, 1.4);
                         self.alpha = 1.0f;
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.3
                                          animations:^{
                                              
                                              self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                              [self applyHeartBeatAnimation:YES];
                                          }];
                     }];
}

- (void)applyHeartBeatAnimation:(BOOL)apply
{
    if (!apply) {
        
        [self.layer removeAnimationForKey:kADVHeartBeatAnimationKey];
        
        return;
    }
    
    CABasicAnimation *heartBeatAnimation;
    
    heartBeatAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    heartBeatAnimation.duration = 0.5;
    heartBeatAnimation.repeatCount = INFINITY;
    heartBeatAnimation.autoreverses = YES;
    heartBeatAnimation.fromValue = @1.0f;
    heartBeatAnimation.toValue = @1.15f;

    [self.layer addAnimation:heartBeatAnimation
                      forKey:kADVHeartBeatAnimationKey];
}

- (void)prepareForMenu
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    scaleAnimation.fromValue = @1.5f;
    scaleAnimation.toValue = @1.0f;
    scaleAnimation.duration = 0.5f;
    
    self.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
    [self.layer addAnimation:scaleAnimation forKey:nil];
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    //interface builder fix
    if (self.userInteractionEnabled == userInteractionEnabled) {
        
        return;
    }
    
    [super setUserInteractionEnabled:userInteractionEnabled];
    [self.layer removeAllAnimations];
    
    CGFloat animationDuration = 0.5f;
    
    CGFloat viewSize = self.frame.size.width;// / (userInteractionEnabled ? 1.5f : 1.0f);
    CGFloat edgeSize = 20;
    
    CGRect realBounds = CGRectMake(0, 0, viewSize, viewSize);
    
    //MASK SETUP
    UIBezierPath *basePath = [UIBezierPath bezierPathWithRect:realBounds];
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(viewSize*0.5, viewSize*0.5, 0, 0)];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(edgeSize, edgeSize, viewSize-edgeSize*2.0, viewSize-edgeSize*2.0)];
    
    [startPath appendPath:basePath];
    [endPath appendPath:basePath];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = realBounds;
    maskLayer.path = userInteractionEnabled ? startPath.CGPath : endPath.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    self.layer.mask = maskLayer;
    
    //ANIMATIONS
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
   
    scaleAnimation.fromValue = userInteractionEnabled ? @1.5f : @1.0f;
    scaleAnimation.toValue = userInteractionEnabled ? @1.0f : @1.5f;
    scaleAnimation.duration = animationDuration;
    
    CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:kADVMaskAnimationKey];
    
    maskAnimation.fromValue = userInteractionEnabled ? (__bridge id)endPath.CGPath : (__bridge id)startPath.CGPath;
    maskAnimation.toValue = userInteractionEnabled ? (__bridge id)startPath.CGPath : (__bridge id)endPath.CGPath;
    maskAnimation.duration = animationDuration;
    
    [maskLayer addAnimation:maskAnimation forKey:kADVMaskAnimationKey];
   
    self.layer.transform = userInteractionEnabled ? CATransform3DMakeScale(1.0, 1.0, 1.0) : CATransform3DMakeScale(1.5, 1.5, 1.5);
    [self.layer addAnimation:scaleAnimation forKey:kADVScaleButtonKey];
}

@end
