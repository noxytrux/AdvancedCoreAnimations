//
//  ViewController.m
//  AdvancedAnimations
//
//  Created by Marcin Pędzimąż on 26.12.2014.
//  Copyright (c) 2014 Marcin Pedzimaz. All rights reserved.
//

#import "ADVViewController.h"
#import "ADVIdleViewController.h"
#import "ADVRecordButton.h"
#import "UIColor+Utilities.h"
#import "ADVShapeLayer.h"

const CGFloat kADVFakeRecordDurationTime = 5.0f;
NSString * const kADVEmbedSegueIdentifier = @"ADVEmbedIdleSegueIdentifier";
NSString * const kADVPieAnimationKey = @"animatePie";

@interface ADVViewController ()

@property (weak, nonatomic) IBOutlet UIView *idleContainerView;
@property (weak, nonatomic) IBOutlet ADVRecordButton *recordButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuButtons;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, weak) ADVIdleViewController *idleViewController;
@property (nonatomic, getter=isRecordButtonOpen) BOOL recordButtonOpen;

@property (nonatomic, weak) ADVShapeLayer *recordingAnimatedLayer;

//menu constraints

@end

@implementation ADVViewController

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    _recordButtonOpen = YES; //ivar so we do not call setter on setup
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icn_bg"]];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleMenuTapGesture:)];
    [self.view addGestureRecognizer:self.tapGesture];
    
    self.recordButton.alpha = 0.0f;
    self.recordButton.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
}

- (void)setRecordButtonOpen:(BOOL)recordButtonOpen
{
    _recordButtonOpen = recordButtonOpen;
    
    [self.idleViewController setIdleMenuHidden:!recordButtonOpen];
    [self.recordButton animateButtonHidden:recordButtonOpen];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:kADVEmbedSegueIdentifier]) {
        
        self.idleViewController = segue.destinationViewController;
    }
}

- (void)handleMenuTapGesture:(UITapGestureRecognizer *)recognizer
{
    self.recordButtonOpen ^= YES;
}

- (IBAction)handleRecordButtonPress:(UIButton *)sender
{
    //disable all screen interaction
    self.tapGesture.enabled = NO;
    self.recordButton.userInteractionEnabled = NO;
    
    //fake record animation for 5sec duration.
    
    [self setupArcRecordAnimationWithDuration:kADVFakeRecordDurationTime];
}

- (void)setupArcRecordAnimationWithDuration:(CGFloat)animationDuration
{
    ADVShapeLayer *pieChartLayer = [[ADVShapeLayer alloc] init];
    pieChartLayer.bounds = CGRectMake(0, 0, 170, 170);
    pieChartLayer.startAngle = -M_PI_2;
    pieChartLayer.endAngle = -M_PI_2;
   
    pieChartLayer.redChannel = 0.196;
    pieChartLayer.greenChannel = 0.804;
    pieChartLayer.blueChannel = 0.196;
    
    pieChartLayer.animationDuration = animationDuration;
    pieChartLayer.position = self.view.center;
    
    [self.view.layer addSublayer:pieChartLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
    
                       pieChartLayer.endAngle = (M_PI * 2.0)-M_PI_2;
                       pieChartLayer.redChannel = 1;
                       pieChartLayer.greenChannel = 0.157;
                       pieChartLayer.blueChannel = 0.0;

                   });
    
    //rotate pie while filling
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
   
    rotationAnimation.fromValue = @0.0f;
    rotationAnimation.toValue = @(2.0f * M_PI);
    rotationAnimation.duration = animationDuration;
    rotationAnimation.delegate = self;
    
    [pieChartLayer addAnimation:rotationAnimation forKey:kADVPieAnimationKey];
    
    self.recordingAnimatedLayer = pieChartLayer;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //fire up magnus opus menu
    
    CABasicAnimation *ropacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    
    ropacityAnimation.fromValue = @1.0f;
    ropacityAnimation.toValue = @0.0f;
    ropacityAnimation.duration = 0.5f;
    
    self.recordingAnimatedLayer.opacity = 0.0f;
    [self.recordingAnimatedLayer addAnimation:ropacityAnimation forKey:nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    scaleAnimation.fromValue = @1.5f;
    scaleAnimation.toValue = @1.0f;
    scaleAnimation.duration = 0.5f;
    
    self.recordButton.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
    [self.recordButton.layer addAnimation:scaleAnimation forKey:nil];
    

    [self openActionMenu];
}

- (void)openActionMenu
{
    //reset constraints
    for (UIButton *btn in self.menuButtons) {
        
        btn.center = self.view.center;
    }
    
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"tag"
                                                               ascending:YES];
    
    NSArray *sortedButtons = [self.menuButtons sortedArrayUsingDescriptors:@[sortDesc]];
    
    CGFloat delay = 0.1f;
    
    NSArray *constraintValues = @[ @[@0, @0],
                                   @[@0, @120],
                                   @[@(-110), @50],
                                   @[@(-80), @(-90)],
                                   @[@80, @(-90)],
                                   @[@110, @50]];
    
    for (NSUInteger i=0; i<sortedButtons.count; ++i) {
        
        UIButton *btn = sortedButtons[i];
        NSArray *values = constraintValues[i];
        
        [UIView animateWithDuration:0.2
                              delay:delay
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             btn.alpha = 1.0f;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [UIView animateWithDuration:0.8
                              delay:delay
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             CGPoint newCenter = btn.center;
                             newCenter.x += [values[0] floatValue];
                             newCenter.y += [values[1] floatValue];
                             
                             btn.center = newCenter;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
        delay += 0.25;
    }
}

- (void)closeActionMenu
{
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"tag"
                                                               ascending:YES];
    
    NSArray *sortedButtons = [self.menuButtons sortedArrayUsingDescriptors:@[sortDesc]];
 
    CGFloat delay = 0.1f;
    
    for (NSUInteger i=0; i<sortedButtons.count; ++i) {
        
        UIButton *btn = sortedButtons[i];
        
        [UIView animateWithDuration:0.2
                              delay:delay
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             btn.alpha = 0.0f;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
        [UIView animateWithDuration:0.8
                              delay:delay
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             btn.center = self.view.center;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
        delay += 0.25;
    }
}

- (IBAction)handleMenuButtonPress:(UIButton *)sender
{
    [self.recordingAnimatedLayer removeFromSuperlayer];
    
    self.tapGesture.enabled = YES;
    self.recordButton.userInteractionEnabled = YES;
    [self.recordButton animateButtonHidden:NO];
    
    [self closeActionMenu];
}

@end
