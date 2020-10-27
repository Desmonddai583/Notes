//
//  ViewController.m
//  02-iOS9新特性之泛型
//
//  Created by xiaomage on 16/3/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

/*
    泛型:限制类型 
    为什么要推出泛型?迎合swift
 
    泛型作用:1.限制类型 2.提高代码规划,减少沟通成本,一看就知道集合中是什么东西
    泛型定义用法:类型<限制类型>
    泛型声明:在声明类的时候,在类的后面<泛型名称>
    泛型仅仅是报警告
    泛型好处:1.从数组中取出来,可以使用点语法
            2.给数组添加元素,有提示
    
    泛型在开发中使用场景:1.用于限制集合类型
 
    id是不能使用点语法
 
    为什么集合可以使用泛型?使用泛型,必须要先声明泛型? => 如何声明泛型
 
    自定义泛型?
    什么时候使用泛型?在声明类的时候,不确定某些属性或者方法类型,在使用这个类的时候才确定,就可以采用泛型
 
    自定义Person,会一些编程语言(iOS,Java),在声明Person,不确定这个人会什么,在使用Person才知道这个Person会什么语言
    如果没有定义泛型.默认就是id
 */

#import "Person.h"
#import "Java.h"
#import "iOS.h"
@interface ViewController ()

@property (nonatomic, strong) NSMutableArray<NSString *> *arr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Java *java = [[Java alloc] init];
    iOS *ios = [[iOS alloc] init];
    
    // iOS
    Person<iOS *> *p = [[Person alloc] init];
    p.language = ios;
    
    // Java
    Person<Java *> *p1 = [[Person alloc] init];
    p1.language = java;

    
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end
