//
//  QCLineProgressView.h
//  画弧线进度（贝塞尔曲线）
//
//  Created by huangzhangcheng on 16/5/26.
//  Copyright © 2016年 huangzhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCLineProgressView : UIView

@property (nonatomic, strong) UIColor *trackColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic) float progress;//0~1之间的数
@property (nonatomic) float progressWidth;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
