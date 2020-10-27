//
//  ViewController.m
//  02-了解-pthread简单使用
//
//  Created by xiaomage on 16/2/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   
}

- (IBAction)btnClick:(id)sender {

    
    
//    NSLog(@"%@",[NSThread currentThread]);
    
    //1.创建线程对象
    pthread_t thread;
    
    //2.创建线程
    /*
     第一个参数:线程对象 传递地址
     第二个参数:线程的属性 NULL
     第三个参数:指向函数的指针
     第四个参数:函数需要接受的参数
     */
    pthread_create(&thread, NULL, task, NULL);
    
    
//    //1.创建线程对象
//    pthread_t threadB;
//    
//    //2.创建线程
//    /*
//     第一个参数:线程对象 传递地址
//     第二个参数:线程的属性 NULL
//     第三个参数:指向函数的指针
//     第四个参数:函数需要接受的参数
//     */
//    pthread_create(&threadB, NULL, task, NULL);
//    
//    pthread_equal(<#pthread_t#>, <#pthread_t#>)

}

void *task(void *param)
{
    for (NSInteger i = 0; i<10000; i++) {
        NSLog(@"%zd----%@",i,[NSThread currentThread]);
    }
    
//    NSLog(@"%@--------",[NSThread currentThread]);
    return NULL;
}

@end
