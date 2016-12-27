//
//  ViewController.m
//  chart
//
//  Created by apple on 2016/12/26.
//  Copyright © 2016年 wuhao. All rights reserved.
//

#import "ViewController.h"
#import "WHLineChart.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WHLineChart * lineChart = [[WHLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    lineChart.title = @"xx小学各年级人数占比";
    lineChart.xLineValueArray = [NSMutableArray arrayWithObjects:@"280", @"255", @"308", @"273", @"236", @"267",@"179",@"231",@"56",@"199",@"200",@"306", nil];
    lineChart.xLineTitleArray = [NSMutableArray arrayWithObjects:@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", @"7年级",@"8年级",@"9年级",@"10年级",@"11年级",@"12年级",nil];
    lineChart.yLineMaxValue = 500;
    lineChart.yLineSectionCount = 10;
    [self.view addSubview:lineChart];
    [lineChart strokePath];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
