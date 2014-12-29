//
//  ADVShapeLayer.h
//  AdvancedAnimations
//
//  Created by Marcin Pędzimąż on 28.12.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

@import UIKit;
@import QuartzCore;

typedef void(^ADVCompletionBlock)(void);

@interface ADVShapeLayer : CALayer

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;

//we cannot animate UIColor directly so we will do some hack on it
@property (nonatomic) CGFloat redChannel;
@property (nonatomic) CGFloat greenChannel;
@property (nonatomic) CGFloat blueChannel;

@property (nonatomic) CGFloat animationDuration;

@property (nonatomic, copy) ADVCompletionBlock completionBlock;

- (void)rotateAround;
- (void)fadeOut;

@end
