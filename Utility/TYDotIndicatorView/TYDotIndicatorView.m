//
//  TYDotIndicatorView.m
//  TYDotIndicatorView
//
//  Created by Tu You on 14-1-12.
//  Copyright (c) 2014年 Tu You. All rights reserved.
//

#import "TYDotIndicatorView.h"
#import "macro.h"
static const NSUInteger dotNumber = 7;
static const CGFloat dotSeparatorDistance = 10.0f;

@interface TYDotIndicatorView ()

@property (nonatomic, assign) TYDotIndicatorViewStyle dotStyle;
@property (nonatomic, assign) CGSize dotSize;
@property (nonatomic, retain) NSMutableArray *dots;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign) BOOL permitAnimating;
@property (nonatomic, strong) CAShapeLayer *moveDot;
@end

@implementation TYDotIndicatorView

- (id)initWithFrame:(CGRect)frame dotStyle:(TYDotIndicatorViewStyle)style dotColor:(UIColor *)dotColor dotSize:(CGSize)dotSize
{
    self = [super initWithFrame:frame];
    if (self){
        _dotStyle = style;
        _dotSize = dotSize;
        
        _dots = [[NSMutableArray alloc] init];
        
        _permitAnimating = YES;
        CGFloat xPos = dotSeparatorDistance*mKwidth - dotSize.width;
        CGFloat yPos = CGRectGetHeight(frame) / 2 - _dotSize.height / 2;
        
        for (int i = 0; i < dotNumber; i++){
            CAShapeLayer *dot = [CAShapeLayer new];
            dot.path = [self createDotPath].CGPath;
            dot.frame = CGRectMake(xPos, yPos, _dotSize.width, _dotSize.height);
            dot.opacity = 0.3;
            dot.fillColor = dotColor.CGColor;
            [self.layer addSublayer:dot];
            [_dots addObject:dot];
            xPos = xPos + dotSeparatorDistance*mKwidth;
        }
    }
    return self;
}

- (UIBezierPath *)createDotPath{
    CGFloat cornerRadius = 0.0f;
    if (_dotStyle == TYDotIndicatorViewStyleSquare)
    {
        cornerRadius = 0.0f;
    }
    else if (_dotStyle == TYDotIndicatorViewStyleRound)
    {
        cornerRadius = 2;
    }
    else if (_dotStyle == TYDotIndicatorViewStyleCircle)
    {
        cornerRadius = self.dotSize.width / 2;
    }
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.dotSize.width, self.dotSize.height) cornerRadius:cornerRadius];
    return bezierPath;
}

- (CAAnimation *)fadeInAnimation:(CFTimeInterval)delay{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    CFTimeInterval lastDotInterval = 1.7f;
    if (delay >= lastDotInterval) {
        animation.delegate = self;
    }
    animation.fromValue = @(0.3f);
    animation.toValue = @(1.0f);
    animation.repeatCount = 0;
    animation.beginTime = delay + CACurrentMediaTime();
    animation.duration= 0.3f ;
    animation.removedOnCompletion=YES;
    animation.fillMode = kCAFillModeBackwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.autoreverses=YES;
    return animation;
}

- (void)startAnimating{
    if (_animating){
        return;
    }
    for (int i = 0; i < _dots.count; i++){
        // 闪烁
        [_dots[i] addAnimation:[self fadeInAnimation:i *0.3f] forKey:@"fadeIn"];
    }
    _animating = YES;
}

- (void)stopAnimating{
    if (!_animating){
        return;
    }
    _permitAnimating = NO;
    for (int i = 0; i < _dots.count; i++){
        [_dots[i] removeAnimationForKey:@"fadeIn"];
    }
    _animating = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (_permitAnimating == YES) {
        _animating = NO;
        [self startAnimating];
    }
}

@end
