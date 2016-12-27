//
//  ZFLine.h
//  ZFChartView
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFLine : UIView

/** 终点的坐标 */
@property (nonatomic, assign) CGPoint endPoint;
/** 是否带阴影效果(默认为YES) */
@property (nonatomic, assign) BOOL isShadow;

#pragma mark - public method

/**
 *  初始化方法
 *
 *  @param startPoint 开始的位置
 *  @param endPoint   结束的位置
 *
 *  @return self
 */
- (instancetype)initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**
 *  重绘
 */
- (void)strokePath;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com