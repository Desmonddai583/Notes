//
//  XMGArenaViewController.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/10.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGArenaViewController.h"

@interface XMGArenaViewController ()

@end

@implementation XMGArenaViewController

- (void)loadView{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgImageView.image = [UIImage imageNamed:@"NLArenaBackground"];
    
    // 必须设置和用户交互
    bgImageView.userInteractionEnabled = YES;
    
//    [self.view addSubview:bgImageView];
    self.view = bgImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // titView
    UISegmentedControl *segMentController = [[UISegmentedControl alloc] initWithItems:@[@"足球",@"篮球"]];
    
    self.navigationItem.titleView = segMentController;
    // 设置文字
    [segMentController setTitleTextAttributes:@{
                                               NSFontAttributeName : [UIFont systemFontOfSize:15],
                                               NSForegroundColorAttributeName: [UIColor whiteColor]
                                               } forState:UIControlStateNormal];
    
    // 设置背景图片
    [segMentController setBackgroundImage:[UIImage imageNamed:@"CPArenaSegmentBG"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segMentController setBackgroundImage:[UIImage imageNamed:@"CPArenaSegmentSelectedBG"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    segMentController.selectedSegmentIndex = 0;
    // 设置前景色
    segMentController.tintColor = [UIColor colorWithRed:0 green:142/255.0f blue:143/255.0f alpha:1];
    
}

@end
