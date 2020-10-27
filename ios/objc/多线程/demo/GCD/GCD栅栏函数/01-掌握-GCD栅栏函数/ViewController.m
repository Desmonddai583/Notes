//
//  ViewController.m
//  01-掌握-GCD栅栏函数
//
//  Created by xiaomage on 16/2/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //0.获得全局并发队列
    //栅栏函数不能使用全局并发队列
    //dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue = dispatch_queue_create("download", DISPATCH_QUEUE_CONCURRENT);
    
    //1.异步函数
    dispatch_async(queue, ^{
       
        for (NSInteger i = 0; i<100; i++) {
            NSLog(@"download1-%zd-%@",i,[NSThread currentThread]);
        }
        
    });
    
    dispatch_async(queue, ^{
        
        for (NSInteger i = 0; i<100; i++) {
            NSLog(@"download2-%zd-%@",i,[NSThread currentThread]);
        }
    });
    
    
    //栅栏函数
    dispatch_barrier_async(queue, ^{
       
        NSLog(@"+++++++++++++++++++++++++++++");
    });
    
    dispatch_async(queue, ^{
        
        for (NSInteger i = 0; i<100; i++) {
            NSLog(@"download3-%zd-%@",i,[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        
        for (NSInteger i = 0; i<100; i++) {
            NSLog(@"download4-%zd-%@",i,[NSThread currentThread]);
        }
    });
}

@end
