//
//  ZFGenericChart.h
//  ZFChartView
//
//  Created by apple on 16/2/5.
//  Copyright © 2016年 apple. All rights reserved.
//

/**
 *  通用坐标轴图表
 */

#import <UIKit/UIKit.h>

@interface ZFGenericChart : UIView

/** x轴数值数组 */
@property (nonatomic, strong) NSMutableArray * xLineValueArray;
/** x轴名字数组 */
@property (nonatomic, strong) NSMutableArray * xLineTitleArray;
/** y轴数值显示的上限 */
@property (nonatomic, assign) float yLineMaxValue;
/** y轴数值显示的段数 */
@property (nonatomic, assign) NSInteger yLineSectionCount;
/** x轴上名称字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat xLineTitleFontSize;
/** x轴上数值字体大小(默认为10.f) */
@property (nonatomic, assign) CGFloat xLineValueFontSize;

#warning message - readonly(只读)

/** 获取坐标轴起点x值 */
@property (nonatomic, assign, readonly) CGFloat axisStartXPos;
/** 获取坐标轴起点Y值 */
@property (nonatomic, assign, readonly) CGFloat axisStartYPos;
/** 获取y轴最大上限值y值 */
@property (nonatomic, assign, readonly) CGFloat yLineMaxValueYPos;
/** 获取y轴最大上限值与0值的高度 */
@property (nonatomic, assign, readonly) CGFloat yLineMaxValueHeight;
/** y轴结束Y位置(从数学坐标轴(0.0)(左下角)开始) */
@property (nonatomic, assign, readonly) CGFloat yLineEndYPos;

#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com