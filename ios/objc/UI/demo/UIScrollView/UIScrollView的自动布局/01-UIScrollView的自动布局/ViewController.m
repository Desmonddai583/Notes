//
//  ViewController.m
//  01-UIScrollView的自动布局
//
//  Created by xiaomage on 16/3/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

/*
 
    UIScrollView做自动布局: 首先确定scrollView滚动范围 => 如何在stroboard对scrollView确定滚动范围 => 搞一个专门view去确定scrollView的滚动范围 => 如何确定:水平 和 垂直方向 => scrollView水平能否滚动: view的宽度 + 左右两边间距 才能确定scrollView水平滚动区域 => 垂直 = view的高度 + 上下两边间距
 
 
 */

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
