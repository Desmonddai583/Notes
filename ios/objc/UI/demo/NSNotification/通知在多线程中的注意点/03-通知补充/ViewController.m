//
//  ViewController.m
//  03-通知补充
//
//  Created by xiaomage on 16/3/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

/*
    通知: 
    1.如何发出通知
    2.监听通知
    3.通知注意点
    4.在多线程中注意点
 */

@interface ViewController ()

@property (nonatomic, weak) id observe;
@end

@implementation ViewController
- (void)test
{
    // 方式一:
    // Observer:观察者
    // selector:只要一监听到通知,就会调用观察者这个方法
    // Name:通知名称
    // object:谁发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNote) name:@"note" object:nil];

}

- (void)test2
{
    // Name:通知名称
    // object:谁发出的通知
    // queue:决定block在哪个线程执行,nil:在发布通知的线程中执行
    // [NSOperationQueue mainQueue]:一般都是使用主队列
    // usingBlock:只要监听到通知,就会执行这个block
    // 注意:一定要记得移除
    _observe = [[NSNotificationCenter defaultCenter] addObserverForName:@"note" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        // 只要监听到通知 就会调用
        NSLog(@"%@",[NSThread currentThread]);
        
        NSLog(@"%@",self);
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 通知顺序:一定要先监听,在发出
    // bug:监听不到通知,马上想到有可能先发出通知,在监听通知
    
    // 监听通知:异步
    // 在异步线程,可以监听通知
    // 2.异步任务,执行顺序不确定
    // 异步:监听通知 主线程:发出通知
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        // 异步任务
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNote) name:@"note" object:nil];
//    });
    
    
    // 主线程:监听通知 异步:发出通知
    // 方式一:
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNote) name:@"note" object:nil];
    
    // 方式二:监听
    _observe = [[NSNotificationCenter defaultCenter] addObserverForName:@"note" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        // 更新UI
        
        // 只要监听到通知 就会调用
        NSLog(@"%@",[NSThread currentThread]);
        
//        NSLog(@"%@",self);
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 发出通知
    // Name:通知名称
    // object:谁发出的通知
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"note" object:nil];
    });
}

// 一个对象即将销毁就会调用
- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:_observe];
}

// 监听到通知就会调用
// 异步:监听通知 主线程:发出通知 接收通知代码在主线程
// 主线程:监听通知 异步:发出通知 接收通知代码在异步
// 注意:在接收通知代码中 可以加上主队列任务

// 总结:接收通知代码 由 发出通知线程决定
- (void)reciveNote
{
    // 更新UI
    dispatch_sync(dispatch_get_main_queue(), ^{
       // 更新UI
        
    });
    NSLog(@"%@",[NSThread currentThread]);
    
    
    
    NSLog(@"接收到通知");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
