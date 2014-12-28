//
//  UIImage+Utilities.m
//  AdvancedAnimations
//
//  Created by Marcin Pędzimąż on 27.12.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

#import "UIImage+Utilities.h"

@implementation UIImage (Utilities)

+ (UIImage *)arcImageWithRadius:(CGFloat )radius
                    borderColor:(UIColor *)color
{
    CGFloat size = 2.0*radius;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
   
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, 0);
    
    CGMutablePathRef arc = CGPathCreateMutable();
    
    CGPathAddArc(arc, NULL,
                 size * 0.5f, size * 0.5f,
                 radius,
                 0.0,
                 M_PI * 2.0,
                 YES);
    
    CGPathRef strokedArc =
    CGPathCreateCopyByStrokingPath(arc, NULL,
                                   2,
                                   kCGLineCapButt,
                                   kCGLineJoinMiter,
                                   10.0f);
    
    CGContextAddPath(context, strokedArc);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithRadius:(CGFloat)radius
                       color:(UIColor *)fillColor
{
    CGFloat size = 2.0*radius;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetLineWidth(context, 0.0);
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, CGRectMake(0.0,
                                                  0.0,
                                                  size,
                                                  size));
    CGContextDrawPath(context, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
