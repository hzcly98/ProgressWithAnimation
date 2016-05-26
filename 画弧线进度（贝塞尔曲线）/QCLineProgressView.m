//
//  QCLineProgressView.m
//  画弧线进度（贝塞尔曲线）
//
//  Created by huangzhangcheng on 16/5/26.
//  Copyright © 2016年 huangzhangcheng. All rights reserved.
//

#import "QCLineProgressView.h"

@interface QCLineProgressView (){
    CAShapeLayer *_trackLayer;
    UIBezierPath *_trackPath;
    CAShapeLayer *_progressLayer;
    UIBezierPath *_progressPath;
}

@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat addNum;
@property (nonatomic, assign) CGFloat currentNum;

@end

@implementation QCLineProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _trackLayer = [CAShapeLayer new];
        [self.layer addSublayer:_trackLayer];
        _trackLayer.fillColor = nil;
        _trackLayer.lineCap = kCALineCapRound;
        _trackLayer.frame = self.bounds;
        
        _progressLayer = [CAShapeLayer new];
        [self.layer addSublayer:_progressLayer];
        _progressLayer.fillColor = nil;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.frame = self.bounds;
        
        //默认的一些值
        self.progressWidth = 5;
        self.trackColor = [UIColor lightGrayColor];
        self.progressColor = [UIColor blackColor];
        
        CGFloat fontSize = 20;
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.bounds = CGRectMake(0, 0, 80, fontSize);
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:fontSize];
        [self addSubview:_progressLabel];
    }
    return self;
}

/**
 *  设置背景进度条
 */
- (void)setTrack
{
    _trackPath = [UIBezierPath bezierPath];
    [_trackPath moveToPoint:CGPointMake(0, (self.bounds.size.height ) / 2)];
    [_trackPath addLineToPoint:CGPointMake(self.bounds.size.width, (self.bounds.size.height) / 2)];
    _trackLayer.path = _trackPath.CGPath;
}

/**
 *  设置实际进度条
 */
- (void)setProgress
{
    _progressPath = [UIBezierPath bezierPath];
    [_progressPath moveToPoint:CGPointMake(0, (self.bounds.size.height) / 2)];
    [_progressPath addLineToPoint:CGPointMake(self.bounds.size.width * _progress, (self.bounds.size.height) / 2)];
    _progressLayer.path = _progressPath.CGPath;
    
    [self setLabelValueWith:_progress];
}


- (void)setProgressWidth:(float)progressWidth
{
    _progressWidth = progressWidth;
    _trackLayer.lineWidth = _progressWidth;
    _progressLayer.lineWidth = _progressWidth;
    
    [self setTrack];
}

- (void)setTrackColor:(UIColor *)trackColor
{
    _trackLayer.strokeColor = trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    
    [self setProgress];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    _progress = progress;
    
    if (animated)
    {
        
        _progressPath = [UIBezierPath bezierPath];
        [_progressPath moveToPoint:CGPointMake(0, (self.bounds.size.height) / 2)];
        [_progressPath addLineToPoint:CGPointMake(self.bounds.size.width * _progress, (self.bounds.size.height) / 2)];
        _progressLayer.path = _progressPath.CGPath;
        
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.duration = 1;
        strokeAnimation.fromValue = @(0.0f);
//        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        strokeAnimation.fillMode = kCAFillModeForwards;
        strokeAnimation.removedOnCompletion = NO;
        [_progressLayer addAnimation:strokeAnimation forKey:@"strokeAnimation"];
        
        [self animationWithLabel];
        
    }
    else
    {
        _progressPath = [UIBezierPath bezierPath];
        [_progressPath moveToPoint:CGPointMake(0, (self.bounds.size.height) / 2)];
        [_progressPath addLineToPoint:CGPointMake(self.bounds.size.width * _progress, (self.bounds.size.height) / 2)];
        _progressLayer.path = _progressPath.CGPath;
        
        [self setLabelValueWith:_progress];
    }
    
}

- (void)animationWithLabel
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(beginAnimation) userInfo:nil repeats:YES];
    _currentNum = 0;
    _addNum = _progress / 50;
}


- (void)beginAnimation
{
    
    _currentNum += _addNum;
    if (_currentNum > _progress)
    {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    
    [self setLabelValueWith:_currentNum];
}

- (void)setLabelValueWith:(CGFloat)num
{
    NSString *str = [NSString stringWithFormat:@"%g%%",(num * 100)];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(attri.length - 1, 1)];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:211/255.0 green:89/255.0 blue:26/255.0 alpha:1] range:NSMakeRange(0, attri.length - 1)];
    _progressLabel.attributedText = attri;
    
    _progressLabel.center = CGPointMake(self.bounds.size.width * num, self.bounds.size.height / 2 + _progressLabel.bounds.size.height / 2 + 10);
}
@end
