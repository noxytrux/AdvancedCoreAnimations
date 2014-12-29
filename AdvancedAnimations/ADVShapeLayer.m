//
//  ADVShapeLayer.m
//  AdvancedAnimations
//
//  Created by Marcin Pędzimąż on 28.12.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

#import "ADVShapeLayer.h"
#import "UIColor+Utilities.h"

NSString * const kADVPieAnimationKey = @"animatePie";

@implementation ADVShapeLayer

@dynamic startAngle;
@dynamic endAngle;

@dynamic fillColor;

-(CABasicAnimation *)makeAnimationForKey:(NSString *)key
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:key];
    anim.fromValue = [[self presentationLayer] valueForKey:key];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = self.animationDuration;
    
    return anim;
}

- (instancetype)init
{
    
    self = [super init];
    
    if (self) {
       
        self.fillColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0].CGColor;
        self.animationDuration = 0.5f;
        
        [self setNeedsDisplay];
    }
    
    return self;
}

- (instancetype)initWithLayer:(id)layer
{
    
    if (self = [super initWithLayer:layer]) {
        
        if ([layer isKindOfClass:[ADVShapeLayer class]]) {
            
            ADVShapeLayer *other = (ADVShapeLayer *)layer;
            self.startAngle = other.startAngle;
            self.endAngle = other.endAngle;
            self.fillColor = other.fillColor;
        }
    }
    
    return self;
}

- (id<CAAction>)actionForKey:(NSString *)event
{
    
    if ([event isEqualToString:NSStringFromSelector(@selector(startAngle))] ||
        [event isEqualToString:NSStringFromSelector(@selector(endAngle))] ||
        [event isEqualToString:NSStringFromSelector(@selector(fillColor))] ){
        
        return [self makeAnimationForKey:event];
    }
    
    return [super actionForKey:event];
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{

    if ([key isEqualToString:NSStringFromSelector(@selector(startAngle))] ||
        [key isEqualToString:NSStringFromSelector(@selector(endAngle))] ||
        [key isEqualToString:NSStringFromSelector(@selector(fillColor))] ) {
        
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx
{
    
    CGPoint center = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height*0.5);
    CGFloat radius = fminf(center.x, center.y);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, center.x, center.y);
    CGPoint p1 = CGPointMake(center.x + radius * cosf(self.startAngle), center.y + radius * sinf(self.startAngle));
    CGContextAddLineToPoint(ctx, p1.x, p1.y);
    
    BOOL clockwise = self.startAngle > self.endAngle;
   
    CGContextAddArc(ctx, center.x, center.y, radius, self.startAngle, self.endAngle, clockwise);
    CGContextClosePath(ctx);

    CGContextSetFillColorWithColor(ctx, self.fillColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextSetLineWidth(ctx, 0);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

- (void)rotateAround
{
    //rotate pie while filling
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    rotationAnimation.fromValue = @0.0f;
    rotationAnimation.toValue = @(2.0f * M_PI);
    rotationAnimation.duration = self.animationDuration;
    rotationAnimation.delegate = self;
    
    [self addAnimation:rotationAnimation forKey:kADVPieAnimationKey];
}

- (void)fadeOut
{
    CABasicAnimation *ropacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    ropacityAnimation.fromValue = @1.0f;
    ropacityAnimation.toValue = @0.0f;
    ropacityAnimation.duration = 0.5f;
    
    self.opacity = 0.0f;
    
    [self addAnimation:ropacityAnimation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.completionBlock) {
        
        self.completionBlock();
    }
}

@end
