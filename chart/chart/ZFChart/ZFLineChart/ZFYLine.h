//
//  ZFYLine.h
//  ZFChartView
//
//  Created by apple on 2016/12/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFYLine : UIView
/** y轴数值显示的段数(默认5段) */
@property (nonatomic, assign) NSInteger yLineSectionCount;
/** y轴开始x位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat yLineStartXPos;
/** y轴结束x位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat yLineEndXPos;
/** y轴开始Y位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat yLineStartYPos;
/** y轴结束Y位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat yLineEndYPos;
/** 计算y轴分段高度的平均值 */
@property (nonatomic, assign, readonly) CGFloat yLineSectionHeightAverage;
/** y轴宽度 */
@property (nonatomic, assign) CGFloat yLineWidth;
/** y轴高度 */
@property (nonatomic, assign) CGFloat yLineHeight;
@property (nonatomic, assign) float yLineMaxValue;
- (void)strokePath;
@end
