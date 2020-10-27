//
//  ViewController.m
//  04-Runtime(动态添加属性)
//
//  Created by xiaomage on 16/3/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+Property.h"

// 动态添加属性:什么时候需要动态添加属性

// 开发场景
// 给系统的类添加属性的时候,可以使用runtime动态添加属性方法

// 本质:动态添加属性,就是让某个属性与对象产生关联

// 需求:让一个NSObject类 保存一个字符串

// runtime一般都是针对系统的类


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSObject *objc = [[NSObject alloc] init];
    
    objc.name = @"123";
    
    NSLog(@"%@",objc.name);
    
    // 创建字符串对象
//    NSString *str = [NSString stringWithString:@"123"];
//    
//    Person *p = [[Person alloc] init];
//    
//    p.name = str;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
