//
//  UIImage+Utilities.h
//  AdvancedAnimations
//
//  Created by Marcin Pędzimąż on 27.12.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

@import UIKit;

@interface UIImage (Utilities)

+ (UIImage *)arcImageWithRadius:(CGFloat )radius
                    borderColor:(UIColor *)color;

+ (UIImage *)imageWithRadius:(CGFloat)radius
                       color:(UIColor *)fillColor;

@end
