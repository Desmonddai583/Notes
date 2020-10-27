//
//  ViewController.m
//  08-UIView的常见属性(尺寸和位置)
//
//  Created by xiaomage on 15/12/25.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
/** label */
@property (nonatomic, weak) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建UILabel对象
    UILabel *label = [[UILabel alloc] init];
    // 设置frame (位置和尺寸)
    label.frame = CGRectMake(100, 100, 100, 60);
    // 设置背景颜色
    label.backgroundColor = [UIColor yellowColor];
    
    // 添加到控制器的view中
    [self.view addSubview:label];
    self.label = label;
}


- (IBAction)bounds {
    // 改变尺寸  iOS9以后, 中心点不变,向四周延伸
    self.label.bounds = CGRectMake(0, 0, 200, 120);
}


- (IBAction)center {
   // 改变位置
//    self.label.center = CGPointMake(100, 100);
    
    // 显示在最中间
    self.label.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    
}

- (IBAction)changeFrame {
    // 方式1
//    self.label.frame = CGRectMake(200, 100, 100, 60);
    
    // 方式2
    self.label.frame = (CGRect){{100, 100}, {100, 100}};
    
    // 方式3
    // 结构体是值传递,不是地址传递
//    self.label.frame.size.width += 100;
    CGRect frame = self.label.frame;
//    frame.origin.x -= 100; // 改变x值
//    frame.origin.y += 100; // 改变y值
//    frame.size.width += 50; // 改变宽度
    frame.size.height += 100; // 改变高度
    self.label.frame = frame;
    

}

@end
