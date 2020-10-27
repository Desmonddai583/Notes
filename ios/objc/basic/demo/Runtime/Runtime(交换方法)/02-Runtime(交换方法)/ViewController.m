//
//  ViewController.m
//  02-Runtime(交换方法)
//
//  Created by xiaomage on 16/3/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

/*
    Runtime(交换方法):只要想修改系统的方法实现
    
    需求:
 
    比如说有一个项目,已经开发了2年,忽然项目负责人添加一个功能,每次UIImage加载图片,告诉我是否加载成功
 
    // 给系统的imageNamed添加功能,只能使用runtime(交互方法)
    // 1.给系统的方法添加分类
    // 2.自己实现一个带有扩展功能的方法
    // 3.交互方法,只需要交互一次,
 
    // 1.自定义UIImage
 
    // 2.UIImage添加分类
 
    弊端:
        1.每次使用,都需要导入
        2.项目大了,没办法实现
 
 */

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // imageNamed => xmg_imageNamed 交互这两个方法实现
    UIImage *image = [UIImage imageNamed:@"1.png"];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
