//
//  ViewController.m
//  03-事件的传递
//
//  Created by xiaomage on 16/1/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//1.当一个控件如果它的父控件不能够接收事件,那么它里面子控件也是不能接收事件的
//2.当一个控件隐藏的时候,它里面的子控件也跟着隐藏
//3.当一个控件透明的时候,它里面的子控件也跟着透明

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
