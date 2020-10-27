//
//  XMGMyLotteryViewController.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/10.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGMyLotteryViewController.h"
#import "XMGSettingTableViewController.h"

@interface XMGMyLotteryViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation XMGMyLotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1.导航条左侧按钮
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setImage:[UIImage imageNamed:@"FBMM_Barbutton"] forState:UIControlStateNormal];
    [leftButton setTitle:@"客服" forState:UIControlStateNormal];
    
    // 自动计算尺寸
    [leftButton sizeToFit];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // 2.设置导航条右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginal:@"Mylottery_config"] style:UIBarButtonItemStylePlain target:self action:@selector(rightOnClick)];
    
    // 3.拉伸登陆按钮
    [self.loginBtn setBackgroundImage:[UIImage stretchableImageName:@"RedButton"] forState:UIControlStateNormal];
    
}

// 导航条右侧点击按钮调用的方法
- (void)rightOnClick{
//    NSLog(@"%s",__func__);
    
    XMGSettingTableViewController *setting = [[XMGSettingTableViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

@end
