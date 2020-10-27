//
//  MainViewController.m
//  02-示例程序-切换颜色
//
//  Created by xiaomage on 15/12/25.
//  Copyright © 2015年 小码哥. All rights reserved.
//

/*
   判断一个对象是否能连线方法:
   看该对象的类是否继承于UIControl
 
 */

#import "MainViewController.h"

@interface MainViewController ()

// 已经有强指针指向
@property (nonatomic, weak)IBOutlet UILabel *label;
/** 属性2 没有必要*/
@property (nonatomic, weak)IBOutlet UILabel *testLabel;

/** 红色的按钮 */
@property (nonatomic, weak)IBOutlet UIButton *redButton;

@end

@implementation MainViewController

#pragma mark - 点击红色按钮
- (IBAction)clickRedButton{
    UISwitch;
    
   // 改变文字的颜色
    self.label.textColor = [UIColor redColor];
    // 改变文本的内容
    self.label.text = @"我是一段红色的文字";
    // 改变背景颜色
    self.label.backgroundColor = [UIColor greenColor];
    // 文字居中
    self.label.textAlignment = NSTextAlignmentCenter;
    // 改变文字的大小
    self.label.font = [UIFont systemFontOfSize:20.f];
    
    // 改变按钮的背景颜色
    self.redButton.backgroundColor = [UIColor redColor];
}

#pragma mark - 点击绿色按钮
- (IBAction)clickGreenButton{
    // 改变文字的颜色
    self.label.textColor = [UIColor greenColor];
    // 改变文本的内容
    self.label.text = @"绿色的文字是我";
    // 改变背景颜色
    self.label.backgroundColor = [UIColor redColor];
    // 文字居中
    self.label.textAlignment = NSTextAlignmentCenter;
    // 改变文字的大小
    self.label.font = [UIFont systemFontOfSize:30.f];
}

#pragma mark - 点击蓝色按钮
- (IBAction)clickBlueButton{
    // 改变文字的颜色
    self.label.textColor = [UIColor blueColor];
    // 改变文本的内容
    self.label.text = @"我是HelloWorld!!!!";
    // 改变背景颜色
    self.label.backgroundColor = [UIColor yellowColor];
    // 文字居中
    self.label.textAlignment = NSTextAlignmentCenter;
    // 改变文字的大小
    self.label.font = [UIFont systemFontOfSize:40.f];
}


- (IBAction)clickLabel{
    NSLog(@"------");
}


- (IBAction)clickBtn:(UIButton *)button {
    NSLog(@"%@", button);
}


@end
