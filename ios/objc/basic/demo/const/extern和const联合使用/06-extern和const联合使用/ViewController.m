//
//  ViewController.m
//  06-extern和const联合使用
//
//  Created by xiaomage on 16/3/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "GlobeConst.h"
// 规定:全局变量不能定义在自己类中,自己创建全局文件管理全局东西


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSUserDefaults standardUserDefaults] setObject:@"123" forKey:discover_name];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[NSUserDefaults standardUserDefaults] objectForKey:discover_name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
