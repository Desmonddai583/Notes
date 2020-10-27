//
//  ViewController.m
//  01-父子控制器(简介)
//
//  Created by xiaomage on 16/3/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "ScoietyViewController.h"
#import "HotViewController.h"
#import "TopLineViewController.h"

/*
    父子控制器:多控制器管理,导航控制器,UITabBarController
 
    默认UITabBarController,实现这种效果,父子实战
    永远只会显示一个view,把之前的view移除
    UITabBarController有个专门存放子控制器view,占位视图思想,1.不用去考虑子控制器的view尺寸 2.屏幕适配也不用管理
 
    1.添加所有子控制器
    2.设置对应按钮的内容,按钮内容由对应子控制器
 
 */

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *titleContainView;
@property (weak, nonatomic) IBOutlet UIView *containView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加所有的子控制器
    [self setupAllViewController];
    // 2.设置按钮的内容
    [self setupTitleButton];
}

// 设置按钮的内容
- (void)setupTitleButton
{
    NSInteger count = self.titleContainView.subviews.count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.titleContainView.subviews[i];
        UIViewController *vc = self.childViewControllers[i];
        [btn setTitle:vc.title forState:UIControlStateNormal];
    }
}

// 添加所有的子控制器
- (void)setupAllViewController
{
    // 社会
    ScoietyViewController *scoietyVc = [[ScoietyViewController alloc] init];
    scoietyVc.title = @"社会";
    [self addChildViewController:scoietyVc];
    
    // 头条
    TopLineViewController *topLineVc = [[TopLineViewController alloc] init];
    topLineVc.title = @"头条";
    [self addChildViewController:topLineVc];
    
    // 热点
    HotViewController *hotVc = [[HotViewController alloc] init];
    hotVc.title = @"热点";
    [self addChildViewController:hotVc];
    
}

// 点击标题按钮
- (IBAction)showChildVcView:(UIButton *)sender {
    
    // 移除之前控制器的view
    [self.containView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    for (UIView *vcView in self.containView.subviews) {
//        [vcView removeFromSuperview];
//    }
    
    // 把对应子控制器的view添加上去
    UIViewController *vc = self.childViewControllers[sender.tag];
    vc.view.backgroundColor = sender.backgroundColor;
    vc.view.frame = self.containView.bounds;
    [self.containView addSubview:vc.view];
}

@end
