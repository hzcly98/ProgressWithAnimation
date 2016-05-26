//
//  QCProgressView.m
//  画弧线进度（贝塞尔曲线）
//
//  Created by huangzhangcheng on 16/5/23.
//  Copyright © 2016年 huangzhangcheng. All rights reserved.
//

#import "QCProgressView.h"
#import <POP/POP.h>

@interface QCProgressView (){
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

@implementation QCProgressView

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
        
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        _progressLabel.bounds = CGRectMake(0, 0, frame.size.width - 20, 60);
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.font = [UIFont systemFontOfSize:60];
        [self addSubview:_progressLabel];
    }
    return self;
}

- (void)setTrack
{
    _trackPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.height / 2, self.bounds.size.width / 2) radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:-5 * M_PI_4 endAngle:M_PI_4 clockwise:YES];
    _trackLayer.path = _trackPath.CGPath;
}

- (void)setProgress
{
    CGFloat end = -5*M_PI_4+(6*M_PI_4*_progress);
    _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.height / 2, self.bounds.size.width / 2) radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:-5 * M_PI_4 endAngle:end clockwise:YES];
    _progressLayer.path = _progressPath.CGPath;
    
   [self setLabelValueWith:_progress];
}


- (void)setProgressWidth:(float)progressWidth
{
    _progressWidth = progressWidth;
    _trackLayer.lineWidth = _progressWidth;
    _progressLayer.lineWidth = _progressWidth;
    
    [self setTrack];
//    [self setProgress];
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
        float end = -5*M_PI_4+(6*M_PI_4*_progress);
        _progressPath = [UIBezierPath bezierPath];
        [_progressPath addArcWithCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:-5 * M_PI_4 endAngle:end clockwise:YES];
        CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeAnimation.duration = 1;
        strokeAnimation.fromValue = @(0.0f);
//        strokeAnimation.beginTime = CACurrentMediaTime() + 0.5;
        strokeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        strokeAnimation.fillMode = kCAFillModeForwards;
        strokeAnimation.removedOnCompletion = NO;
        [_progressLayer addAnimation:strokeAnimation forKey:@"checkAnimation"];
        _progressLayer.path = _progressPath.CGPath;
        
        [self animationWithLabel];
 
    }
    else
    {
        CGFloat end = -5*M_PI_4+(6*M_PI_4*progress);
        _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.height / 2, self.bounds.size.width / 2) radius:(self.bounds.size.width - _progressWidth)/ 2 startAngle:-5 * M_PI_4 endAngle:end clockwise:YES];
        _progressLayer.path = _progressPath.CGPath;
        
       [self setLabelValueWith:_progress];
    }
    
}

- (void)animationWithLabel
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animationLabel) userInfo:nil repeats:YES];
    _currentNum = 0;
    _addNum = _progress / 50;
}


- (void)animationLabel
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
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(attri.length - 1, 1)];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:211/255.0 green:89/255.0 blue:26/255.0 alpha:1] range:NSMakeRange(0, attri.length - 1)];
    _progressLabel.attributedText = attri;
}

@end
