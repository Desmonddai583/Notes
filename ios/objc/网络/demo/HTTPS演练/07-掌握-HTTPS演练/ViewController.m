//
//  ViewController.m
//  07-掌握-HTTPS演练
//
//  Created by xiaomage on 16/2/27.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()<NSURLSessionDataDelegate>

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self afn];
}

-(void)afn
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //更改解析方式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置对证书的处理方式
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    
    [manager GET:@"https://kyfw.12306.cn/otn" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success---%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error---%@",error);
    }];
}

-(void)session
{
    //1.确定url
    NSURL *url = [NSURL URLWithString:@"https://kyfw.12306.cn/otn"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.创建session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //4.创建Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //5.解析数据
        NSLog(@"%@---%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding],error);
    }];
    
    //6.执行task
    [dataTask resume];
}

#pragma mark ----------------------
#pragma mark NSURLSessionDataDelegate
//如果发送的请求是https的,那么才会调用该方法
//challenge 质询,挑战
//NSURLAuthenticationMethodServerTrust
-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    if(![challenge.protectionSpace.authenticationMethod isEqualToString:@"NSURLAuthenticationMethodServerTrust"])
    {
        return;
    }
    NSLog(@"%@",challenge.protectionSpace);
    //NSURLSessionAuthChallengeDisposition 如何处理证书
    /*
     NSURLSessionAuthChallengeUseCredential = 0, 使用该证书 安装该证书
     NSURLSessionAuthChallengePerformDefaultHandling = 1, 默认采用的方式,该证书被忽略
     NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2, 取消请求,证书忽略
     NSURLSessionAuthChallengeRejectProtectionSpace = 3,          拒绝
     */
    NSURLCredential *credential = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
    
    //NSURLCredential 授权信息
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
}

@end
