//
//  ADVRecordButton.h
//  AdvancedAnimations
//
//  Created by Marcin Pędzimąż on 28.12.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

@import UIKit;

IB_DESIGNABLE

@interface ADVRecordButton : UIButton

@property(nonatomic) IBInspectable CGFloat defaultSpacing;
@property(nonatomic) IBInspectable CGFloat textOffset;

- (void)animateButtonHidden:(BOOL)hidden;

@end
