//
//  ViewController.m
//  04-掌握-NSURLSession的基本使用
//
//  Created by xiaomage on 16/2/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self post];
}

-(void)get
{
    //1.确定URL
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520it&pwd=520it&type=JSON"];
    
    //2.创建请求对象
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    //3.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.创建Task
    /*
     第一个参数:请求对象
     第二个参数:completionHandler 当请求完成之后调用
        data:响应体信息
        response:响应头信息
        error:错误信息当请求失败的时候 error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //6.解析数据
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    //5.执行Task
    [dataTask resume];
}

-(void)get2
{
    //1.确定URL
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=520it&pwd=520it&type=JSON"];
    
    //2.创建请求对象
    //NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    //3.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.创建Task
    /*
     第一个参数:请求路径
     第二个参数:completionHandler 当请求完成之后调用
     data:响应体信息
     response:响应头信息
     error:错误信息当请求失败的时候 error有值
     注意:dataTaskWithURL 内部会自动的将请求路径作为参数创建一个请求对象(GET)
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //6.解析数据
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    //5.执行Task
    [dataTask resume];
}

-(void)post
{
    //1.确定URL
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    
    //2.创建请求对象
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    
    //2.1 设置请求方法为post
    request.HTTPMethod = @"POST";
    
    //2.2 设置请求体
    request.HTTPBody = [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    
    //3.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.创建Task
    /*
     第一个参数:请求对象
     第二个参数:completionHandler 当请求完成之后调用 !!! 在子线程中调用
     data:响应体信息
     response:响应头信息
     error:错误信息当请求失败的时候 error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@",[NSThread currentThread]);
        //6.解析数据
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    //5.执行Task
    [dataTask resume];
}

@end
