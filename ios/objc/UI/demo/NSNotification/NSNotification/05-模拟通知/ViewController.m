//
//  ViewController.m
//  05-模拟通知
//
//  Created by xiaomage on 16/1/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGPerson.h"
#import "XMGCompany.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XMGCompany *com1 = [[XMGCompany alloc] init];
    com1.name = @"Tencent";
    
    XMGCompany *com2 = [[XMGCompany alloc] init];
    com2.name = @"Sina";
    
    XMGPerson *p1 = [[XMGPerson alloc] init];
    p1.name = @"张三";
    XMGPerson *p2 = [[XMGPerson alloc] init];
    p2.name = @"李四";
    XMGPerson *p3 = [[XMGPerson alloc] init];
    p3.name = @"王五";
    
    /**** 模拟通知 ***/
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:p1 selector:@selector(getNew:) name:nil  object:nil];
    
    // 发布通知
    NSNotification *note = [NSNotification notificationWithName:@"军事新闻" object:com1 userInfo:@{@"title": @"XXXXXXX"}];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"军事新闻" object:com2 userInfo:@{@"title": @"XXXXXXXXYYYYYY"}];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"娱乐新闻" object:com1 userInfo:@{@"title": @"XXXXXXXXYYYYYY"}];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"娱乐新闻" object:com2 userInfo:@{@"title": @"XXXXXXXXYYYYYY"}];
    
    // 匿名通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"军事新闻" object:nil userInfo:@{@"title": @"XXXXXXXXYYYYYY"}];
    
    // 移除通知
//    [[NSNotificationCenter defaultCenter] removeObserver:p1 name:@"军事新闻" object:com1];
    [[NSNotificationCenter defaultCenter] removeObserver:p1];
    
    
    /**** UIDevice *****/
    // 系统适配
//    double version = [UIDevice currentDevice].systemVersion.doubleValue;
//    
//    if (version >= 9.0) {
//        
//    } else if (version >= 8.0) {
//        
//    } else {
//        
//    }
}
@end
