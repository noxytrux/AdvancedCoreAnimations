//
//  UIColor+Utilities.m
//  AdvancedAnimations
//
//  Created by Marcin Pędzimąż on 28.12.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

#import "UIColor+Utilities.h"

@implementation UIColor (Utilities)

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    return [[self class] colorFromHexString:hexString
                         withAlphaComponent:1.0];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString withAlphaComponent:(CGFloat)alpha
{
    if (hexString == nil) {
        return nil;
    }
    
    NSError *error;
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"\\A#[0-9a-f]{6}\\z"
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:&error];
    
    NSInteger count = [regexp numberOfMatchesInString:hexString
                                              options:NSMatchingReportProgress
                                                range:NSMakeRange(0, [hexString length])];
    
    if (count != 1) {
        return nil;
    }
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                           alpha:alpha];
    
}

@end
