//
//  XMGOperation.m
//  07-了解-NSOperationQueue的基本使用
//
//  Created by xiaomage on 16/2/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGOperation.h"

@implementation XMGOperation

//告知要执行的任务是什么
//1.有利于代码隐蔽
//2.复用性
-(void)main
{
    NSLog(@"main---%@",[NSThread currentThread]);
}
@end
