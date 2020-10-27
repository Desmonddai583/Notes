//
//  XMGOperation.m
//  09-掌握-NSOperationQueue其它用法
//
//  Created by xiaomage on 16/2/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGOperation.h"

@implementation XMGOperation

-(void)main
{
    //3个耗时操作
    for (NSInteger i = 0; i<100000;i++ ) {
        NSLog(@"download1---%zd--%@",i,[NSThread currentThread]);
    }
    
    //苹果官方的建议:每执行完一小段耗时操作的时候判断当前操作时候被取消
    if(self.isCancelled) return;
    
    NSLog(@"+++++++++++++++");
    
    for (NSInteger i = 0; i<1000;i++ ) {
        NSLog(@"download2---%zd--%@",i,[NSThread currentThread]);
    }
    
    if(self.isCancelled) return;
    NSLog(@"+++++++++++++++");
    
    for (NSInteger i = 0; i<1000;i++ ) {
        NSLog(@"download3---%zd--%@",i,[NSThread currentThread]);
    }

}
@end
