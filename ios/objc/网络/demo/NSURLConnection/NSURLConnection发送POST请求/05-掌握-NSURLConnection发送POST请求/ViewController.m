//
//  ViewController.m
//  05-掌握-NSURLConnection发送POST请求
//
//  Created by xiaomage on 16/2/22.
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

-(void)post
{
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    
    //2.创建可变请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //3.修改请求方法,POST必须大写
    request.HTTPMethod = @"POST";
    
    //设置属性,请求超时
    request.timeoutInterval = 10;
    
    //设置请求头User-Agent
    //注意:key一定要一致(用于传递数据给后台)
    [request setValue:@"ios 10.1" forHTTPHeaderField:@"User-Agent"];
    
    //4.设置请求体信息,字符串--->NSData
    request.HTTPBody = [@"username=520it&pwd=123&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    
    //5.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       
        //6.解析数据,NSData --->NSString
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
}

@end
