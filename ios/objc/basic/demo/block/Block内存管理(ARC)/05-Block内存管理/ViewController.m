//
//  ViewController.m
//  05-Block内存管理
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

/*
    block是不是一个对象?是一个对象
 
    如何判断当前文件是MRC,还是ARC
    1.dealloc 能否调用super,只有MRC才能调用super
    2.能否使用retain,release.如果能用就是MRC
 
    ARC管理原则:只要一个对象没有被强指针修饰就会被销毁,默认局部变量对象都是强指针,存放到堆里面
 
    MRC了解开发常识:1.MRC没有strong,weak,局部变量对象就是相当于基本数据类型
                  2.MRC给成员属性赋值,一定要使用set方法,不能直接访问下划线成员属性赋值
 
    总结:只要block没有引用外部局部变量,block放在全局区
 
    MRC:管理block
            只要Block引用外部局部变量,block放在栈里面.
            block只能使用copy,不能使用retain,使用retain,block还是在栈里面
 
 
    ARC:管理block
        只要block引用外部局部变量,block放在堆里面
        block使用strong.最好不要使用copy
 */

@interface ViewController ()

@property (nonatomic, strong) void(^block)();
//@property (nonatomic, copy) void(^block)();

@end

@implementation ViewController

//- (void)setName:(NSString *)name
//{
//    _name = [name copy];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.name = @"123";
    // Do any additional setup after loading the view, typically from a nib.
    // 堆 栈 全局区
    
    int a = 3;
    
    void(^block)() = ^{
        
        NSLog(@"%d",a);
        
    };
    
    _block =  block;
    NSLog(@"%@",_block);
  
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _block();
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
