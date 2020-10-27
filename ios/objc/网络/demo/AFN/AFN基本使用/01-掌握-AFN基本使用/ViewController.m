//
//  ViewController.m
//  01-掌握-AFN基本使用
//
//  Created by xiaomage on 16/2/27.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self post];
}

-(void)get
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //http://120.25.226.186:32812/login?username=123&pwd=122&type=JSON
    //
    
    NSDictionary *paramDict = @{
                                @"username":@"520it",
                                @"pwd":@"520it",
                                @"type":@"JSON"
                                };
    //2.发送GET请求
    /*
     第一个参数:请求路径(不包含参数).NSString
     第二个参数:字典(发送给服务器的数据~参数)
     第三个参数:progress 进度回调
     第四个参数:success 成功回调
                task:请求任务
                responseObject:响应体信息(JSON--->OC对象)
     第五个参数:failure 失败回调
                error:错误信息
     响应头:task.response
     */
    [manager GET:@"http://120.25.226.186:32812/login" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@---%@",[responseObject class],responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *paramDict = @{
                                @"username":@"520it",
                                @"pwd":@"520",
                                @"type":@"JSON"
                                };
    //2.发送GET请求
    /*
     第一个参数:请求路径(不包含参数).NSString
     第二个参数:字典(发送给服务器的数据~参数)
     第三个参数:progress 进度回调
     第四个参数:success 成功回调
        task:请求任务
        responseObject:响应体信息(JSON--->OC对象)
     第五个参数:failure 失败回调
        error:错误信息
     响应头:task.response
     */
    [manager POST:@"http://120.25.226.186:32812/login" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@---%@",[responseObject class],responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}
@end
