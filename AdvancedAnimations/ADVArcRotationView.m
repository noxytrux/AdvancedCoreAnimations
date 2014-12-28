//
//  ADVArcRotationView.m
//  AdvancedAnimations
//
//  Created by Marcin Pędzimąż on 27.12.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

#import "ADVArcRotationView.h"

CGFloat degreeToRadian(CGFloat degree)
{
    return degree * M_PI / 180.0f;
}

@implementation ADVArcRotationView

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
    self.offsetX = 0.0f;
    self.offsetY = 0.0f;
    self.radius = 20.0f;
    
    self.startAngle = 0.0f;
    self.endAngle = 90.0f;
    
    self.lineWidth = 1.0f;
    
    self.fillColor = [UIColor whiteColor];
    self.strokeColor = [UIColor whiteColor];
}

- (void)prepareForInterfaceBuilder
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.offsetX, self.offsetY);
    
    CGMutablePathRef arc = CGPathCreateMutable();
    
    CGPathAddArc(arc, NULL,
                 rect.size.width * 0.5f, rect.size.height * 0.5f,
                 self.radius,
                 degreeToRadian(self.startAngle),
                 degreeToRadian(self.endAngle),
                 YES);
    
    CGPathRef strokedArc =
    CGPathCreateCopyByStrokingPath(arc, NULL,
                                   self.lineWidth,
                                   kCGLineCapButt,
                                   kCGLineJoinMiter,
                                   10.0f);
    
    CGContextAddPath(context, strokedArc);
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
}

@end
