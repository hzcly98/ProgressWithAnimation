//
//  ViewController.m
//  画弧线进度（贝塞尔曲线）
//
//  Created by huangzhangcheng on 16/5/23.
//  Copyright © 2016年 huangzhangcheng. All rights reserved.
//

#import "ViewController.h"
#import "QCProgressView.h"
#import "QCLineProgressView.h"
#import <POP/POP.h>

@interface ViewController ()<POPAnimationDelegate>
@property (nonatomic, strong) UIButton *nextPage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QCProgressView *progress = [[QCProgressView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    progress.center = self.view.center;
    [self.view addSubview:progress];
    progress.trackColor = [UIColor lightGrayColor];
    progress.progressColor = [UIColor colorWithRed:229/255.0 green:83/255.0 blue:156/255.0 alpha:1];
//    progress.progress = 0.95;
    progress.progressWidth = 6;
    [progress setProgress:0.95 animated:YES];
    
    QCLineProgressView *lineProgress = [[QCLineProgressView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    lineProgress.center = CGPointMake(self.view.center.x, 150);
    [self.view addSubview:lineProgress];
    lineProgress.trackColor = [UIColor lightGrayColor];
    lineProgress.progressColor = [UIColor colorWithRed:229/255.0 green:83/255.0 blue:156/255.0 alpha:1];
        lineProgress.progress = 0.95;
    lineProgress.progressWidth = 6;
    [lineProgress setProgress:0.95 animated:YES];
    
    
    self.nextPage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _nextPage.center = CGPointMake(self.view.center.x, self.view.center.y + 150);
    [_nextPage setTitle:@"nextPage" forState:UIControlStateNormal];
    _nextPage.backgroundColor = [UIColor lightGrayColor];
    [_nextPage addTarget:self action:@selector(nextPageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextPage];
    
    
    
}
- (void)nextPageClick:(UIButton *)sender
{
//    sender.layer.cornerRadius = 50;
    POPSpringAnimation *cornerRadiusAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    cornerRadiusAnimation.toValue = @(50);
//    cornerRadiusAnimation.fromValue = @(10);
//    strokeAnimation.beginTime = CACurrentMediaTime() + 0.5;
    cornerRadiusAnimation.springBounciness = 12;
//    strokeAnimation.removedOnCompletion = NO;
    cornerRadiusAnimation.delegate = self;
    [sender.layer pop_addAnimation:cornerRadiusAnimation forKey:@"cornerRadiusAnimation"];
    

}

-(void)pop_animationDidStart:(POPAnimation *)anim
{
//    if([[_nextPage.layer animationForKey:@"cornerRadiusAnimation"] isEqual:anim])
//    {
    
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _nextPage.bounds = CGRectMake(0, 0,100 , 100);
            _nextPage.backgroundColor=[UIColor colorWithRed:1.00f green:0.80f blue:0.56f alpha:1.00f];
        } completion:^(BOOL finished) {
            [_nextPage.layer pop_removeAllAnimations];
            
//            [self checkAnimation];
        }];
        
//    }
}

@end
