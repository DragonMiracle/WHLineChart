//
//  ZFYLine.m
//  ZFChartView
//
//  Created by apple on 2016/12/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFYLine.h"
#import "ZFConst.h"
#import "ZFLabel.h"
@implementation ZFYLine
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}
- (void)commonInit{
    _yLineWidth = 1.f;
    _yLineHeight = self.frame.size.height * 0.7;
    _yLineStartXPos = 50;
    _yLineStartYPos = self.frame.size.height * 0.8;;
    _yLineEndXPos = 50;
    _yLineEndYPos = self.frame.size.height * 0.1;
}
/**
 *  坐标轴起始位置（未填充）
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)axisLineNoFill{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRect:CGRectMake(50, self.frame.size.height * 0.8, 1.f, 1.f)];
    [bezier fill];
    return bezier;
}

/**
 *  画y轴
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawYAxisLine{
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRect:CGRectMake(_yLineEndXPos, _yLineEndYPos, _yLineWidth, _yLineHeight)];
    [bezier stroke];
    return bezier;
}
/**
 *  y轴shapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)yAxisLineShapeLayer{
    CAShapeLayer * yAxisLinelayer = [CAShapeLayer layer];
    yAxisLinelayer.fillColor = [UIColor blackColor].CGColor;
    
    CABasicAnimation * animation = [self animationFromValue:[self axisLineNoFill] toValue:[self drawYAxisLine]];
    [yAxisLinelayer addAnimation:animation forKey:nil];
    
    return yAxisLinelayer;
}
#pragma mark - 箭头

/**
 *  箭头起始位置（未填充）
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)arrowsNoFill{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(_yLineEndXPos + 5 + 0.5, _yLineEndYPos)];
    [bezier addLineToPoint:CGPointMake(_yLineEndXPos - 5 + 0.5, _yLineEndYPos)];
    [bezier stroke];
    
    return bezier;
}
/**
 *  画箭头
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawArrows{
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    [bezier moveToPoint:CGPointMake(_yLineEndXPos + 0.5, _yLineEndYPos - 5 * ZFTan(60))];
    [bezier addLineToPoint:CGPointMake(_yLineEndXPos + 5 + 0.5, _yLineEndYPos)];
    [bezier addLineToPoint:CGPointMake(_yLineEndXPos + 0.5 - 5, _yLineEndYPos)];
    [bezier closePath];
    [bezier fill];
    
    return bezier;
}

/**
 *  箭头CAShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)arrowsShapeLayer{
    CAShapeLayer * arrowsLayer = [CAShapeLayer layer];
    arrowsLayer.fillColor = [UIColor blackColor].CGColor;
    
    CABasicAnimation * animation = [self animationFromValue:[self arrowsNoFill] toValue:[self drawArrows]];
    [arrowsLayer addAnimation:animation forKey:nil];
    
    return arrowsLayer;
}
#pragma mark - y轴分段线

/**
 *  y轴分段线起始位置 (未填充)
 *
 *  @param i 下标
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)yAxisLineSectionNoFill:(NSInteger)i {
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    CGFloat yStartPos = _yLineStartYPos - (_yLineHeight - ZFAxisLineGapFromYLineMaxValueToArrow) / _yLineSectionCount * (i + 1);
    [bezier moveToPoint:CGPointMake(_yLineStartXPos, yStartPos)];
    [bezier addLineToPoint:CGPointMake(_yLineStartXPos, yStartPos)];
    
    return bezier;
}

/**
 *  画y轴分段线
 *
 *  @param i 下标
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)drawYAxisLineSection:(NSInteger)i {
    UIBezierPath * bezier = [UIBezierPath bezierPath];
    CGFloat yStartPos = _yLineStartYPos - (_yLineHeight - ZFAxisLineGapFromYLineMaxValueToArrow) / _yLineSectionCount * (i + 1);
    [bezier moveToPoint:CGPointMake(_yLineStartXPos, yStartPos)];
    [bezier addLineToPoint:CGPointMake(_yLineStartXPos - 5, yStartPos)];
    
    return bezier;
}

/**
 *  y轴分段线CAShapeLayer
 *
 *  @param i 下标
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)yAxisLineSectionShapeLayer:(NSInteger)i {
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor blackColor].CGColor;
    
    CABasicAnimation * animation = [self animationFromValue:[self yAxisLineSectionNoFill:i] toValue:[self drawYAxisLineSection:i]];
    [layer addAnimation:animation forKey:nil];
    
    return layer;
}
/**
 *  填充动画
 *
 *  @return CABasicAnimation
 */
- (CABasicAnimation *)animationFromValue:(UIBezierPath *)fromValue toValue:(UIBezierPath *)toValue{
    CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    fillAnimation.duration = 0.5f;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.fromValue = (id)fromValue.CGPath;
    fillAnimation.toValue = (id)toValue.CGPath;
    
    return fillAnimation;
}
/**
 *  清除之前所有subLayers
 */
- (void)removeAllSubLayers{
    NSArray * subLayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer * layer in subLayers) {
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
}
- (void)setYLineValueLabel{
    for (NSInteger i = 0; i <= _yLineSectionCount; i++) {
        CGFloat width = self.yLineStartXPos;
        CGFloat height = self.yLineSectionHeightAverage;
        CGFloat yStartPos = self.yLineStartYPos - height / 2 - height * i;
        
        ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, yStartPos, width, height)];
        //平均值
        float valueAverage = _yLineMaxValue / _yLineSectionCount;
        label.text = [NSString stringWithFormat:@"%.0f",valueAverage * i];
        [self addSubview:label];
    }
}
#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    [self removeAllSubLayers];
    [self setYLineValueLabel];
    [self.layer addSublayer:[self yAxisLineShapeLayer]];
    
    for (NSInteger i = 0; i < _yLineSectionCount; i++) {
        [self.layer addSublayer:[self yAxisLineSectionShapeLayer:i]];
    }
    
        //延迟0.5秒执行
        NSTimer * timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - 定时器

- (void)timerAction:(NSTimer *)sender{
    [self.layer addSublayer:[self arrowsShapeLayer]];

    [sender invalidate];
    sender = nil;
}

- (CGFloat)yLineSectionHeightAverage{
    return ((_yLineHeight - ZFAxisLineGapFromYLineMaxValueToArrow) / _yLineSectionCount);
}
@end
