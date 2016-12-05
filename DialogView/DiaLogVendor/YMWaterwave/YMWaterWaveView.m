//
//  YMWaterWaveView.m
//  DialogDemo
//
//  Created by yanminli on 2016/11/3.
//  Copyright © 2016年 s3graphics. All rights reserved.
//

#import "YMWaterWaveView.h"
#import "commonHeader.h"

@interface YMWaterWaveView()

@property (nonatomic, strong) CADisplayLink *waveDisplaylink;

@property (nonatomic, strong) CAShapeLayer  *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer  *secondWaveLayer;
@end

@implementation YMWaterWaveView {
    CGFloat waveAmplitude;  // 波纹振幅
    CGFloat waveCycle;      // 波纹周期
    CGFloat waveSpeed;      // 波纹速度
    CGFloat waveGrowth;     // 波纹上升速度
    
    CGFloat waterWaveHeight;
    CGFloat waterWaveWidth;
    CGFloat offsetX;           // 波浪x位移
    CGFloat currentWavePointY; // 当前波浪上市高度Y（高度从大到小 坐标系向下增长）
    
    float variable;     //可变参数 更加真实 模拟波纹
    BOOL increase;      // 增减变化
    YMWaterWaveAnimateType _animateType;//展现时先上升，隐藏时先下降
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)removeFromParentView
{
    [self reset];
    [self removeFromSuperview];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self setUp];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self setUp];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    waterWaveHeight = self.frame.size.height/2;
    waterWaveWidth  = self.frame.size.width;
    if (waterWaveWidth > 0) {
        waveCycle =  1.29 * M_PI / waterWaveWidth;
    }
    
    if (currentWavePointY <= 0) {
        currentWavePointY = self.frame.size.height;
    }
}

- (void)setUp
{
    waterWaveHeight = self.frame.size.height/2;
    waterWaveWidth  = self.frame.size.width;
    _firstWaveColor = COLOR(255, 255, 255, 0.3);
    _secondWaveColor = COLOR(255, 255, 255, 0.3);
    
    waveGrowth = 0.85;
    waveSpeed = 0.4/M_PI;
    
    [self resetProperty];
}

- (void)resetProperty
{
    currentWavePointY = self.frame.size.height;
    
    variable = 1.6;
    increase = NO;
    
    offsetX = 0;
}

- (void)setFirstWaveColor:(UIColor *)firstWaveColor
{
    _firstWaveColor = firstWaveColor;
    _firstWaveLayer.fillColor = firstWaveColor.CGColor;
}

- (void)setSecondWaveColor:(UIColor *)secondWaveColor
{
    _secondWaveColor = secondWaveColor;
    _secondWaveLayer.fillColor = secondWaveColor.CGColor;
}

- (void)setPercent:(CGFloat)percent
{
    _percent = percent;
    [self resetProperty];
}

-(void)startWave
{
    _animateType = YMWaterWaveAnimateTypeShow;
    [self resetProperty];
    
    if (_firstWaveLayer == nil) {
        // 创建第一个波浪Layer
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.fillColor = _firstWaveColor.CGColor;
        [self.layer addSublayer:_firstWaveLayer];
    }
    
    if (_secondWaveLayer == nil) {
        // 创建第二个波浪Layer
        _secondWaveLayer = [CAShapeLayer layer];
        _secondWaveLayer.fillColor = _secondWaveColor.CGColor;
        [self.layer addSublayer:_secondWaveLayer];
    }
    
    if (_waveDisplaylink) {
        [self stopWave];
    }
    
    // 启动定时调用
    _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

-(void) stopWave
{
    _animateType = YMWaterWaveAnimateTypeHide;
    
    //    [_waveDisplaylink invalidate];
    //    _waveDisplaylink = nil;
}

- (void)reset
{
    [_waveDisplaylink invalidate];
    _waveDisplaylink = nil;
    
    [self resetProperty];
    
    [_firstWaveLayer removeFromSuperlayer];
    _firstWaveLayer = nil;
    [_secondWaveLayer removeFromSuperlayer];
    _secondWaveLayer = nil;
}

-(void)animateWave
{
    if (increase) {
        variable += 0.01;
    }else{
        variable -= 0.01;
    }
    
    if (variable<=1) {
        increase = YES;
    }
    
    if (variable>=1.6) {
        increase = NO;
    }
    //int num = [self.delegate volNum];
    waveAmplitude = variable*5;
}

-(void)getCurrentWave:(CADisplayLink *)displayLink
{
    [self animateWave];
    
    if (YMWaterWaveAnimateTypeShow == _animateType && currentWavePointY > 2 * waterWaveHeight *(1-_percent)) {
        // 波浪高度未到指定高度 继续上涨
        currentWavePointY -= waveGrowth;
    } else if (YMWaterWaveAnimateTypeHide == _animateType && currentWavePointY < 2 * waterWaveHeight) {
        currentWavePointY += waveGrowth;
    } else if (YMWaterWaveAnimateTypeHide == _animateType && currentWavePointY == 2 * waterWaveHeight) {
        currentWavePointY +=10;
        [_waveDisplaylink invalidate];
        _waveDisplaylink = nil;
        //[self removeFromParentView];
    }
    
    // 波浪位移
    offsetX += waveSpeed;
    
    [self setCurrentFirstWaveLayerPath];
    [self setCurrentSecondWaveLayerPath];
}

-(void)setCurrentFirstWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        // 正弦波浪公式
        y = waveAmplitude * sin(waveCycle * x + offsetX) + currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _firstWaveLayer.path = path;
    CGPathRelease(path);
}

-(void)setCurrentSecondWaveLayerPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        // 余弦波浪公式
        y = waveAmplitude * cos(waveCycle * x + offsetX) + currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _secondWaveLayer.path = path;
    CGPathRelease(path);
}

- (void)dealloc
{
    [self reset];
}

 

@end
