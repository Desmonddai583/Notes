//
//  ThreeViewController.m
//  10-导航控制器跳转
//
//  Created by xiaomage on 16/1/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ThreeViewController.h"

@interface ThreeViewController ()

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
//返回上一级
- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
//回到指定的控制器
- (IBAction)popToVc:(id)sender {
    //回到指定的控制器必须得是导航控制器的子控制器
    [self.navigationController popToViewController:self.navigationController.childViewControllers[0] animated:YES];
}
//回到根控制器
- (IBAction)backRootVC:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
