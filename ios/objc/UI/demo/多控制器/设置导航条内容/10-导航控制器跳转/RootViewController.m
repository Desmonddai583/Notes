//
//  RootViewController.m
//  10-导航控制器跳转
//
//  Created by xiaomage on 16/1/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "RootViewController.h"
#import "TwoViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航条的内容
    //由栈顶控制器来决定
    //设置标题
    self.navigationItem.title = @"根控制器";
    //设置标题视图
    self.navigationItem.titleView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    //设置左侧标题
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:0 target:self action:@selector(leftClick)];
    
    
     //设置右侧图片
    UIImage *image = [UIImage imageNamed:@"navigationbar_friendsearch"];
    UIImage *oriImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:oriImage style:0 target:self action:@selector(rightClick)];
    
//    
//    
//    //设置右侧是一个自定义的View(位置不需要自己决定,但是大小是要自己决定)
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setImage:[UIImage imageNamed:@"navigationbar_friendsearch"] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"navigationbar_friendsearch_highlighted"] forState:UIControlStateHighlighted];
//    //让按钮自适应大小
//    [btn sizeToFit];
//    
//    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
}

- (void)btnClick{
  NSLog(@"%s",__func__);
}

- (void)leftClick{
    NSLog(@"%s",__func__);
}

- (void)rightClick{
  NSLog(@"%s",__func__);
}


- (IBAction)jumpVc:(id)sender {
    //跳转到第二个控制器
    // self.navigationController获取当前所在的导航控制器
    TwoViewController *twoVC = [[TwoViewController alloc] init];
    [self.navigationController pushViewController:twoVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
