//
//  ViewController.m
//  06-UIView的常见属性
//
//  Created by xiaomage on 15/12/25.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

// 绿色的view
@property (weak, nonatomic) IBOutlet UIView *greenView;

/** 数组 */
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ViewController
/*
- (void)loadView{
    [super loadView];
    NSLog(@"%s", __func__);
}
*/
/**
   1. 系统调用
   2. 控制器的view加载完毕的时候调用
   3. 控件的初始化,数据的初始化(懒加载)
 */
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 1.1 查看绿色的view的父控件
//    NSLog(@"绿色的view的父控件:%@----控制器的view:%@", self.greenView.superview, self.view);
    
    // 1.2 查看绿色的view的子控件
//    NSLog(@"%@", self.greenView.subviews);
    
    // 1.3 控制器的view的子控件
//      NSLog(@"%@", self.view.subviews);
    
    // 1.4 控制器的view的父控件 --> UIWindow
    NSLog(@"viewDidLoad-----%@", self.view.superview);
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear-----%@", self.view.superview);
}


/**
   1. 系统调用
   2. 当控制器接收到内存警告调用
   3. 去除一些不必要的内存,去除耗时的内存
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    self.dataArr = nil;
}

/**
 *  模拟内存警告--->不断增加内存
 */
- (void)test{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<100000000; i++) {
        UILabel *label = [[UILabel alloc] init];
        [arr addObject:label];
    }
    self.dataArr = arr;
}

@end
