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
@property (nonatomic) CGColorRef fillColor;
@property (nonatomic) CGFloat animationDuration;

@property (nonatomic, copy) ADVCompletionBlock completionBlock;

- (void)rotateAround;
- (void)fadeOut;

@end
