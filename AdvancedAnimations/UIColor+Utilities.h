//
//  UIColor+Utilities.h
//  AdvancedAnimations
//
//  Created by Marcin Pędzimąż on 28.12.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

@import UIKit;

@interface UIColor (Utilities)

+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)colorFromHexString:(NSString *)hexString withAlphaComponent:(CGFloat)alpha;

@end
