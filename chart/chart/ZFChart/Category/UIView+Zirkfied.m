//
//  UIView+Zirkfied.m
//  ZFChartView
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIView+Zirkfied.h"

@implementation UIView (Zirkfied)

/**
 *  自定义边框
 *
 *  @param cornerRadius 角落半径
 *  @param borderWidth  边框宽度
 *  @param color        边框颜色
 */
-(void)setBorderCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)color{
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = color.CGColor;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com