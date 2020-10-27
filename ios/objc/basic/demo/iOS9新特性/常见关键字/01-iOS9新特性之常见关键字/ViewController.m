//
//  ViewController.m
//  01-iOS9新特性之常见关键字
//
//  Created by xiaomage on 16/3/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

/*
    怎么去研究新特性? 1.使用新的xcode创建项目,用旧的xcode去打开
    Xcode7 2015 iOS9
    Xcode6 2014 iOS8
    Xcode5 2013 iOS7
    Xcode4 2012 iOS6
 
    1.出了哪些新特性 iOS9:关键字:可以用于属性,方法返回值和参数中
    关键字作用:提示作用,告诉开发者属性信息
    关键字目的:迎合swift,swift是个强语言,swift必须要指定一个对象是否为空
    关键字好处:提高代码规划,减少沟通成本
    关键字仅仅是提供警告,并不会报编译错误
    null_resettable
 
 */

/*
    nullable:1.怎么使用(语法) 2.什么时候使用(作用)
    nullable作用:可能为空
 
    nullable 语法1
    @property (nonatomic, strong, nullable) NSString *name;
 
    nullable 语法2 * 关键字 变量名
    @property (nonatomic, strong) NSString * _Nullable name;
 
    nullable 语法3
    @property (nonatomic, strong) NSString * __nullable name;
 
 */

/*
 nonnull:1.怎么使用(语法) 2.什么时候使用(作用)
 nonnull作用:不能为空
 
 nonnull 语法1
 @property (nonatomic, strong, nullable) NSString *name;
 
 nonnull 语法2 * 关键字 变量名
 @property (nonatomic, strong) NSString * _Nonnull name;
 
 nonnull 语法3
 @property (nonatomic, strong) NSString * __nonnull name;
 
 */

/*
 
 null_resettable:1.怎么使用(语法) 2.什么时候使用(作用)
 
 null_resettable:必须要处理为空情况,重写get方法
 
 null_resettable作用:get方法不能返回nil,set可以传入为空
 
 null_resettable 语法1
 @property (nonatomic, strong, null_resettable) NSString *name;
 
 */

/*
    _Null_unspecified:不确定是否为空
 */

/*
    关键字注意点
    在NS_ASSUME_NONNULL_BEGIN和NS_ASSUME_NONNULL_END之间默认是nonnull
    
    关键字不能用于基本数据类型(int,float),nil只用于对象
 
 
 */

#import "ViewController.h"

@interface ViewController ()

// nonnull
// 没有处理为空的情况
@property (nonatomic, assign, nonnull) int  name;

@end

@implementation ViewController
//- (NSString *)name
//{
//    if (_name == nil) {
//        _name = @"";
//    }
//    return _name;
//}

//- (UIView *)view
//{
//    if (_view == nil) {
//        [self loadView];
//        [self viewDidLoad];
//    }
//    return _view
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
