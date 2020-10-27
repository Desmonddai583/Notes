//
//  ViewController.m
//  02-UIButton(在代码中使用)
//
//  Created by xiaomage on 15/12/28.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.1 创建按钮对象
//    UIButton *button = [[UIButton alloc] init];
    // 注意:设置按钮的类型只能在初始化的时候设置  -> UIButtonTypeCustom
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 1.2 设置按钮的类型
//    button.buttonType = UIButtonTypeInfoDark;
    
    // 1.3 设置frame
    button.frame = CGRectMake(100, 100, 170, 60);
    
    // 1.4 设置背景颜色
//    button.backgroundColor = [UIColor redColor];
//    [button setBackgroundColor:[UIColor redColor]];
    
    // 1.5 设置文字
    // 分状态的:
//    button.titleLabel.text = @"普通文字";
    [button setTitle:@"普通按钮" forState:UIControlStateNormal];
    [button setTitle:@"高亮按钮" forState:UIControlStateHighlighted];
    
    // 1.6 设置文字的颜色
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    
    // 1.7 设置文字的阴影颜色
    [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    button.titleLabel.shadowOffset = CGSizeMake(3, 2);
    
    // 1.8 设置内容图片
    [button setImage:[UIImage imageNamed:@"player_btn_pause_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"player_btn_pause_highlight"] forState:UIControlStateHighlighted];
    
//    button.imageView.backgroundColor = [UIColor purpleColor];
    
    // 1.9 设置背景图片
    [button setBackgroundImage:[UIImage imageNamed:@"buttongreen"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"buttongreen_highlighted"] forState:UIControlStateHighlighted];
    
    // 2.0 加到控制器的view中
    [self.view addSubview:button];
    
    // 非常重要
    /**
     *  监听按钮的点击
     *  Target: 目标 (让谁做事情)
     *  action: 方法 (做什么事情-->方法)
     *  Events: 事件
     */
//    SEL sel = @selector(clickButton:);
    [button addTarget:self action:@selector(demo:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)demo:(UIButton *)btn{
    NSLog(@"%@", btn);
}


- (IBAction)clickButton:(UIButton *)button {
    button.enabled = NO;
}

@end
