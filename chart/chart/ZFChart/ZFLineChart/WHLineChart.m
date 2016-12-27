//
//  WHLineChart.m
//  ZFChartView
//
//  Created by apple on 2016/12/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WHLineChart.h"
#import "ZFGenericChart.h"
#import "ZFLine.h"
#import "ZFCirque.h"
#import "ZFConst.h"
#import "ZFLabel.h"
#import "ZFAxisLine.h"
#import "NSString+Zirkfied.h"
#import "ZFYLine.h"
@interface WHLineChart()<UIScrollViewDelegate>

/** 通用坐标轴图表 */
@property (nonatomic, strong) ZFGenericChart * genericChart;
@property (nonatomic, strong) ZFYLine * YLine;
/** 存储圆环的数组 */
@property (nonatomic, strong) NSMutableArray * cirqueArray;
/** 标题Label */
@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation WHLineChart
- (NSMutableArray *)cirqueArray{
    if (!_cirqueArray) {
        _cirqueArray = [NSMutableArray array];
    }
    return _cirqueArray;
}

/**
 *  初始化变量
 */
- (void)commonInit{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH-50, SCREEN_HEIGHT)];;
    [self addSubview:_scrollView];
    
    _isShowValueOnChart = YES;
    _valueOnChartFontSize = 10.f;
    _valueOnChartPosition = kLineChartValuePositionOnTop;
    _isShadow = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;

}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self drawGenericChart];
    }
    
    return self;
}

#pragma mark - 坐标轴

/**
 *  画坐标轴
 */
- (void)drawGenericChart{
    self.genericChart = [[ZFGenericChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-50, self.frame.size.height)];
    
    [self.scrollView addSubview:self.genericChart];
    
    self.YLine = [[ZFYLine alloc]initWithFrame:CGRectMake(0, 0, 30, self.frame.size.height)];
    [self addSubview:self.YLine];
}
#pragma mark - 画圆环和线

/**
 *  画圆环和线
 */
- (void)drawLineAndCirque{
    [self removeAllLineAndCirque];
    [self removeLabelOnChart];
    [self.cirqueArray removeAllObjects];
    
    //圆环
    for (NSInteger i = 0; i < self.xLineValueArray.count; i++) {
        BOOL isOverrun = NO;//记录是否超出上限
        CGFloat percent = [self.xLineValueArray[i] floatValue] / _yLineMaxValue;
        if (percent > 1) {
            percent = 1.f;
            isOverrun = YES;
        }
        
        CGFloat height = self.genericChart.yLineMaxValueHeight * percent;
        CGFloat y = self.genericChart.axisStartYPos - height;
        CGFloat x = self.genericChart.axisStartXPos + XLineItemGapLength + (XLineItemWidth + XLineItemGapLength) * i + XLineItemWidth / 2;
        
        ZFCirque * cirque = [[ZFCirque alloc] initWithFrame:CGRectMake(x, y, 0, 0)];
        //当前数值超过y轴显示上限时，圆环改为红色
        if (isOverrun == YES) {
            cirque.cirqueColor = [UIColor redColor];
        }
        cirque.isShadow = _isShadow;
        [cirque strokePath];
        [self.genericChart addSubview:cirque];
        [self.cirqueArray addObject:cirque];
    }
    
    //线
    for (NSInteger i = 0; i < self.cirqueArray.count - 1; i++) {
        ZFCirque * cirque = self.cirqueArray[i];
        ZFCirque * nextCirque = self.cirqueArray[i+1];
        
        CGFloat end_XPos = fabs(cirque.center.x - nextCirque.center.x);
        CGFloat end_YPos = nextCirque.center.y - cirque.center.y;
        ZFLine * line = [[ZFLine alloc] initWithStartPoint:CGPointMake(cirque.center.x, cirque.center.y) endPoint:CGPointMake(end_XPos, end_YPos)];
        line.isShadow = _isShadow;
        [line strokePath];
        [self.genericChart addSubview:line];
    }
    
    //圆环上的label
    _isShowValueOnChart ? [self showLabelOnChart] : nil;
}
/**
 *  显示圆环上的label
 */
- (void)showLabelOnChart{
    //圆环上的label
    for (NSInteger i = 0; i < self.cirqueArray.count; i++) {
        ZFCirque * cirque = self.cirqueArray[i];
        //label的中心点
        CGPoint label_center = CGPointMake(0, 0);
        
        //_valueOnChartPosition为上下分布
        if (_valueOnChartPosition == kLineChartValuePositionDefalut) {
            //根据end_YPos判断label显示在圆环上面或下面
            CGFloat end_YPos;
            
            if (i < self.cirqueArray.count - 1) {//当前圆环不是最后一个时
                ZFCirque * nextCirque = self.cirqueArray[i+1];
                end_YPos = nextCirque.center.y - cirque.center.y;
                
            }else{//当前圆环为最后一个时
                ZFCirque * preCirque = self.cirqueArray[i-1];
                end_YPos = preCirque.center.y - cirque.center.y;
                
            }
            
            label_center = end_YPos <= 0 ? CGPointMake(cirque.center.x, cirque.center.y + 20) : CGPointMake(cirque.center.x, cirque.center.y - 20);
            
            //_valueOnChartPosition为圆环上方
        }else if (_valueOnChartPosition == kLineChartValuePositionOnTop){
            label_center = CGPointMake(cirque.center.x, cirque.center.y - 20);
            
            //_valueOnChartPosition为圆环下方
        }else if (_valueOnChartPosition == kLineChartValuePositionOnBelow){
            label_center = CGPointMake(cirque.center.x, cirque.center.y + 20);
            
        }
        
        CGRect rect = [self.xLineValueArray[i] stringWidthRectWithSize:CGSizeMake(45, 30) fontOfSize:_valueOnChartFontSize isBold:NO];
        ZFLabel * label = [[ZFLabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        label.text = self.xLineValueArray[i];
        label.font = [UIFont systemFontOfSize:_valueOnChartFontSize];
        label.center = label_center;
        label.numberOfLines = 0;
        label.isFadeInAnimation = YES;
        [self.scrollView addSubview:label];
    }
}

/**
 *  清除之前所有圆环和线
 */
- (void)removeAllLineAndCirque{
    for (UIView * view in self.genericChart.subviews) {
        if ([view isKindOfClass:[ZFLine class]] || [view isKindOfClass:[ZFCirque class]]) {
            [view removeFromSuperview];
        }
    }
}

/**
 *  清除圆环上的Label
 */
- (void)removeLabelOnChart{
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[ZFLabel class]]) {
            [(ZFLabel *)view removeFromSuperview];
        }
    }
}
#pragma mark - public method

/**
 *  重绘
 */
- (void)strokePath{
    _YLine.yLineMaxValue = _yLineMaxValue;
    [self.YLine strokePath];
    
    [self.genericChart strokePath];
    [self drawLineAndCirque];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.genericChart.frame), self.frame.size.height);
    NSLog(@"%f",CGRectGetWidth(self.genericChart.frame));
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
}

#pragma mark - 重写setter,getter方法

- (void)setXLineTitleArray:(NSMutableArray *)xLineTitleArray{
    _xLineTitleArray = xLineTitleArray;
    self.genericChart.xLineTitleArray = _xLineTitleArray;
}

- (void)setXLineValueArray:(NSMutableArray *)xLineValueArray{
    _xLineValueArray = xLineValueArray;
    self.genericChart.xLineValueArray = _xLineValueArray;
}

- (void)setYLineMaxValue:(float)yLineMaxValue{
    _yLineMaxValue = yLineMaxValue;
    self.genericChart.yLineMaxValue = _yLineMaxValue;
}

- (void)setYLineSectionCount:(NSInteger)yLineSectionCount{
    _yLineSectionCount = yLineSectionCount;
    self.genericChart.yLineSectionCount = _yLineSectionCount;
    self.YLine.yLineSectionCount = _yLineSectionCount;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setXLineTitleFontSize:(CGFloat)xLineTitleFontSize{
    _xLineTitleFontSize = xLineTitleFontSize;
    self.genericChart.xLineTitleFontSize = _xLineTitleFontSize;
}

- (void)setXLineValueFontSize:(CGFloat)xLineValueFontSize{
    _xLineValueFontSize = xLineValueFontSize;
    self.genericChart.xLineValueFontSize = _xLineValueFontSize;
}



@end
