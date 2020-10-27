//
//  XMGBuyViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/30.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGBuyViewController.h"
#import "XMGTitleViewButton.h"

@interface XMGBuyViewController ()

@property (nonatomic, weak) UIButton *button;
@end

@implementation XMGBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置titleView
    UIButton *button = [[XMGTitleViewButton alloc] init];
    [button setImage:[UIImage imageNamed:@"YellowDownArrow"] forState:UIControlStateNormal];
    [button setTitle:@"全部采种" forState:UIControlStateNormal];
    
    [button sizeToFit];
    
    self.button = button;
    
    self.navigationItem.titleView = button;
    
    
    // 2.设置左侧返回按钮
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithRenderOriginalName:@"NavBack"] style:0 target:self action:@selector(back)];
//    self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>
}
//- (void)back{
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.button setTitle:@"全部采种全部采种全部采种" forState:UIControlStateNormal];
//    [self.button sizeToFit];
    
    [self.button setImage:nil forState:UIControlStateNormal];
    
}
@end
