//
//  ViewController.m
//  03-掌握-NSURLConnection和Runloop补充
//
//  Created by xiaomage on 16/2/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self newThreadDelegate2];
}

-(void)delegate1
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://120.25.226.186:32812/login?username=123&pwd=123&type=JSON"]];
    
    //设置代理
    //代理方法:默认是在主线程中调用的
    NSURLConnection *connect = [NSURLConnection connectionWithRequest:request delegate:self];
    
    
    //设置代理方法在哪个线程中调用
    //[NSOperationQueue alloc]init]]    开子线程
    //[NSOperationQueue mainQueue]  不能这样设置
    [connect setDelegateQueue:[[NSOperationQueue alloc]init]];
    //[connect setDelegateQueue:[NSOperationQueue mainQueue]];
    
    NSLog(@"-------");
}

-(void)delegate2
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://120.25.226.186:32812/login?username=123&pwd=123&type=JSON"]];
    
    //设置代理
    //代理方法:默认是在主线程中调用的
    NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];

    
    [connect setDelegateQueue:[[NSOperationQueue alloc]init]];
    
    //开始发送请求
    [connect start];
    NSLog(@"-------");
}

-(void)newThreadDelegate1
{
   dispatch_async(dispatch_get_global_queue(0, 0), ^{
      
       NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://120.25.226.186:32812/login?username=123&pwd=123&type=JSON"]];
       
       //设置代理
       //代理方法:默认是在主线程中调用的
       //该方法内部其实会将connect对象作为一个source添加到当前的runloop中,指定运行模式为默认
       NSURLConnection *connect = [NSURLConnection connectionWithRequest:request delegate:self];
       
       //设置代理方法在哪个线程中调用
       [connect setDelegateQueue:[[NSOperationQueue alloc]init]];
       
       //[[NSRunLoop currentRunLoop] runMode:UITrackingRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1000]];
       [[NSRunLoop currentRunLoop]run];
       
         NSLog(@"---%@----",[NSThread currentThread]);
   });
  
}

-(void)newThreadDelegate2
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://120.25.226.186:32812/login?username=123&pwd=123&type=JSON"]];
        
        //设置代理
        //代理方法:默认是在主线程中调用的
        NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
        
        [connect setDelegateQueue:[[NSOperationQueue alloc]init]];
        
        //开始发送请求
        //如如果connect对象没有添加到runloop中,那么该方法内部会自动的添加到runloop
        //注意:如果当前的runloop没有开启,那么该方法内部会自动获得当前线程对应的runloop对象并且开启
        [connect start];
        NSLog(@"---%@----",[NSThread currentThread]);
    });
}

#pragma mark ----------------------
#pragma mark NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse---%@",[NSThread currentThread]);
}

@end
