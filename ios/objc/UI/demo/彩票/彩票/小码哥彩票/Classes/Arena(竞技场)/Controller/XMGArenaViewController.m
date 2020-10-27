//
//  XMGArenaViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGArenaViewController.h"
#import "UIView+Frame.h"

@interface XMGArenaViewController ()

@end

@implementation XMGArenaViewController

// 当第一次加载view的时候调用
// 如果自定义view,重写这个方法
- (void)loadView{
    // 在这个方法里面不能调用self.view.bounds,如果调用会造成死循环
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [self.view addSubview:imageView];
    self.view = imageView;
    
    // 设置背景图片
    imageView.image = [UIImage imageNamed:@"NLArenaBackground"];
    
    // 设置允许与用户交互
    imageView.userInteractionEnabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置titleView
    UISegmentedControl *segMentControl = [[UISegmentedControl alloc] initWithItems:@[@"足球",@"篮球"]];
    
    // 2.设置背景图片
    // 普通状态
    [segMentControl setBackgroundImage:[UIImage imageNamed:@"CPArenaSegmentBG"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // 选中状态
    [segMentControl setBackgroundImage:[UIImage imageNamed:@"CPArenaSegmentSelectedBG"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    // 3.设置字体颜色
    [segMentControl setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName : [UIColor whiteColor]
                                            } forState:UIControlStateNormal];
    
    // 4.设置选中的索引
    segMentControl.selectedSegmentIndex = 0;
    
    // 5.设置前景色
    segMentControl.tintColor = [UIColor colorWithRed:0 green:142/255.0 blue:143/255.0 alpha:1];
    
    self.navigationItem.titleView = segMentControl;

//    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@""];
//    
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
     [XMGSaveTool setObject:@""   forKey:@""];
    
//    __weak XMGArenaViewController *weakSelf = self;
}
@end
