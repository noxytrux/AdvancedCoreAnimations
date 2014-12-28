//
//  ADVShapeLayer.m
//  AdvancedAnimations
//
//  Created by Marcin Pędzimąż on 28.12.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

#import "ADVShapeLayer.h"
#import "UIColor+Utilities.h"

@implementation ADVShapeLayer

@dynamic startAngle;
@dynamic endAngle;

@dynamic redChannel;
@dynamic greenChannel;
@dynamic blueChannel;

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
       
        self.redChannel = 0.0f;
        self.greenChannel = 1.0f;
        self.blueChannel = 0.0f;
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
            self.redChannel = other.redChannel;
            self.greenChannel = other.greenChannel;
            self.blueChannel = other.blueChannel;
        }
    }
    
    return self;
}

- (id<CAAction>)actionForKey:(NSString *)event
{
    
    if ([event isEqualToString:NSStringFromSelector(@selector(startAngle))] ||
        [event isEqualToString:NSStringFromSelector(@selector(endAngle))] ||
        [event isEqualToString:NSStringFromSelector(@selector(redChannel))] ||
        [event isEqualToString:NSStringFromSelector(@selector(greenChannel))] ||
        [event isEqualToString:NSStringFromSelector(@selector(blueChannel))] ){
        
        return [self makeAnimationForKey:event];
    }
    
    return [super actionForKey:event];
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{

    if ([key isEqualToString:NSStringFromSelector(@selector(startAngle))] ||
        [key isEqualToString:NSStringFromSelector(@selector(endAngle))] ||
        [key isEqualToString:NSStringFromSelector(@selector(redChannel))] ||
        [key isEqualToString:NSStringFromSelector(@selector(greenChannel))] ||
        [key isEqualToString:NSStringFromSelector(@selector(blueChannel))]) {
        
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

    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:self.redChannel green:self.greenChannel blue:self.blueChannel alpha:1.0].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextSetLineWidth(ctx, 0);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end
