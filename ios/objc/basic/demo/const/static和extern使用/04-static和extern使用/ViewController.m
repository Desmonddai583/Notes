//
//  ViewController.m
//  04-static和extern使用
//
//  Created by xiaomage on 16/3/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

int i = 10;

/*
        static: 1.修饰局部变量,被static修饰局部变量,延长生命周期,跟整个应用程序有关
                    * 被static修饰局部变量,只会分配一次内存
                    * 被static修饰局部变量什么分配内存? 程序一运行就会给static修饰变量分配内存
 
                2.修饰全局变量,被static修饰全局变量,作用域会修改,只能在当前文件下使用
 
        extern:声明外部全局变量,注意:extern只能用于声明,不能用于定义
 
        extern工作原理:先会去当前文件下查找有没有对应全局变量,如果没有,才回去其他文件查找
 */

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     int a = 3;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
    i++;
    
    NSLog(@"%d",i);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
