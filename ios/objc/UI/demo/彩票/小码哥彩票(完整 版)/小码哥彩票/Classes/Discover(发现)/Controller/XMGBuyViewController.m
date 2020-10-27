//
//  XMGBuyViewController.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/12.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGBuyViewController.h"
#import "XMGButton.h"

@interface XMGBuyViewController ()
@property (nonatomic, weak) UIButton *button;
@end

@implementation XMGBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置titleView
    UIButton *button = [[XMGButton alloc] init];
    self.button = button;
    [button setTitle:@"全部菜种" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"YellowDownArrow"] forState:UIControlStateNormal];
    
    [button sizeToFit];
    self.navigationItem.titleView = button;
   
    
}

@end
