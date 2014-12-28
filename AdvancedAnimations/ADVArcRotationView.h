//
//  ADVArcRotationView.h
//  AdvancedAnimations
//
//  Created by Marcin Pędzimąż on 27.12.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

@import UIKit;

IB_DESIGNABLE

@interface ADVArcRotationView : UIView

@property (nonatomic) IBInspectable CGFloat offsetX;
@property (nonatomic) IBInspectable CGFloat offsetY;
@property (nonatomic) IBInspectable CGFloat radius;

@property (nonatomic) IBInspectable UIColor *fillColor;
@property (nonatomic) IBInspectable UIColor *strokeColor;
@property (nonatomic) IBInspectable CGFloat lineWidth;

@property (nonatomic) IBInspectable CGFloat startAngle;
@property (nonatomic) IBInspectable CGFloat endAngle;

@end
