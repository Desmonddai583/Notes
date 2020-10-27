//
//  ViewController.m
//  01-掌握-GCD中的定时器
//
//  Created by xiaomage on 16/2/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
/** 注释 */
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
    
    
    //1.创建GCD中的定时器
    /*
     第一个参数:source的类型DISPATCH_SOURCE_TYPE_TIMER 表示是定时器
     第二个参数:描述信息,线程ID
     第三个参数:更详细的描述信息
     第四个参数:队列,决定GCD定时器中的任务在哪个线程中执行
     */
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    
    //2.设置定时器(起始时间|间隔时间|精准度)
    /*
     第一个参数:定时器对象
     第二个参数:起始时间,DISPATCH_TIME_NOW 从现在开始计时
     第三个参数:间隔时间 2.0 GCD中时间单位为纳秒
     第四个参数:精准度 绝对精准0
     */
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    //3.设置定时器执行的任务
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"GCD---%@",[NSThread currentThread]);
    });
    
    //4.启动执行
    dispatch_resume(timer);
    
    self.timer = timer;
}
@end
