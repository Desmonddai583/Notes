//
//  ViewController.m
//  02-掌握-GCD的快速迭代
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
    [self moveFileWithGCD];
}

-(void)forDemo
{
    //同步
    for (NSInteger i = 0; i<10; i++) {
        NSLog(@"%zd---%@",i,[NSThread currentThread]);
    }
}

//开子线程和主线程一起完成遍历任务,任务的执行时并发的
-(void)applyDemo
{
    /*
     第一个参数:遍历的次数
     第二个参数:队列(并发队列)
     第三个参数:index 索引
     */
    dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSLog(@"%zd---%@",index,[NSThread currentThread]);
    });
}

//使用for循环
-(void)moveFile
{
    //1.拿到文件路径
    NSString *from = @"/Users/xiaomage/Desktop/from";
    
    //2.获得目标文件路径
    NSString *to = @"/Users/xiaomage/Desktop/to";
    
    //3.得到目录下面的所有文件
    NSArray *subPaths = [[NSFileManager defaultManager] subpathsAtPath:from];
    
    NSLog(@"%@",subPaths);
    //4.遍历所有文件,然后执行剪切操作
    NSInteger count = subPaths.count;
    
    for (NSInteger i = 0; i< count; i++) {
        
        //4.1 拼接文件的全路径
       // NSString *fullPath = [from stringByAppendingString:subPaths[i]];
        //在拼接的时候会自动添加/
        NSString *fullPath = [from stringByAppendingPathComponent:subPaths[i]];
        NSString *toFullPath = [to stringByAppendingPathComponent:subPaths[i]];
        
        NSLog(@"%@",fullPath);
        //4.2 执行剪切操作
        /*
         第一个参数:要剪切的文件在哪里
         第二个参数:文件应该被存到哪个位置
         */
        [[NSFileManager defaultManager]moveItemAtPath:fullPath toPath:toFullPath error:nil];
        
        NSLog(@"%@---%@--%@",fullPath,toFullPath,[NSThread currentThread]);
    }
}

-(void)moveFileWithGCD
{
    //1.拿到文件路径
    NSString *from = @"/Users/xiaomage/Desktop/from";
    
    //2.获得目标文件路径
    NSString *to = @"/Users/xiaomage/Desktop/to";
    
    //3.得到目录下面的所有文件
    NSArray *subPaths = [[NSFileManager defaultManager] subpathsAtPath:from];
    
    NSLog(@"%@",subPaths);
    //4.遍历所有文件,然后执行剪切操作
    NSInteger count = subPaths.count;
    
    dispatch_apply(count, dispatch_get_global_queue(0, 0), ^(size_t i) {
        //4.1 拼接文件的全路径
        // NSString *fullPath = [from stringByAppendingString:subPaths[i]];
        //在拼接的时候会自动添加/
        NSString *fullPath = [from stringByAppendingPathComponent:subPaths[i]];
        NSString *toFullPath = [to stringByAppendingPathComponent:subPaths[i]];
        
        NSLog(@"%@",fullPath);
        //4.2 执行剪切操作
        /*
         第一个参数:要剪切的文件在哪里
         第二个参数:文件应该被存到哪个位置
         */
        [[NSFileManager defaultManager]moveItemAtPath:fullPath toPath:toFullPath error:nil];
        
        NSLog(@"%@---%@--%@",fullPath,toFullPath,[NSThread currentThread]);

    });
}
@end
