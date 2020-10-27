//
//  ViewController.m
//  05-掌握-NSURLSession相关代理方法
//
//  Created by xiaomage on 16/2/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDataDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *proessView;
/** 接受响应体信息 */
@property (nonatomic, strong) NSFileHandle *handle;
@property (nonatomic, assign) NSInteger totalSize;
@property (nonatomic, assign) NSInteger currentSize;
@property (nonatomic, strong) NSString *fullPath;
@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1.url
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.创建会话对象,设置代理
    /*
     第一个参数:配置信息 [NSURLSessionConfiguration defaultSessionConfiguration]
     第二个参数:代理
     第三个参数:设置代理方法在哪个线程中调用
     */
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //4.创建Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    //5.执行Task
    [dataTask resume];
}

#pragma mark ----------------------
#pragma mark NSURLSessionDataDelegate
/**
 *  1.接收到服务器的响应 它默认会取消该请求
 *
 *  @param session           会话对象
 *  @param dataTask          请求任务
 *  @param response          响应头信息
 *  @param completionHandler 回调 传给系统
 */
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //获得文件的总大小
    self.totalSize = response.expectedContentLength;
    
    //获得文件全路径
    self.fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
    
    //创建空的文件
    [[NSFileManager defaultManager]createFileAtPath:self.fullPath contents:nil attributes:nil];
    
    //创建文件句柄
    self.handle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
    
    [self.handle seekToEndOfFile];
    /*
     NSURLSessionResponseCancel = 0,取消 默认
     NSURLSessionResponseAllow = 1, 接收
     NSURLSessionResponseBecomeDownload = 2, 变成下载任务
     NSURLSessionResponseBecomeStream        变成流
     */
    completionHandler(NSURLSessionResponseAllow);
}

/**
 *  接收到服务器返回的数据 调用多次
 *
 *  @param session           会话对象
 *  @param dataTask          请求任务
 *  @param data              本次下载的数据
 */
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    
    //写入数据到文件
    [self.handle writeData:data];
    
    //计算文件的下载进度
    self.currentSize += data.length;
    NSLog(@"%f",1.0 * self.currentSize / self.totalSize);
    
    self.proessView.progress = 1.0 * self.currentSize / self.totalSize;
}

/**
 *  请求结束或者是失败的时候调用
 *
 *  @param session           会话对象
 *  @param dataTask          请求任务
 *  @param error             错误信息
 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"%@",self.fullPath);
    
    //关闭文件句柄
    [self.handle closeFile];
    self.handle = nil;
}


@end
