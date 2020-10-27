//
//  ViewController.m
//  05-掌握-NSURLSession相关代理方法
//
//  Created by xiaomage on 16/2/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#define FileName @"121212.mp4"

@interface ViewController ()<NSURLSessionDataDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *proessView;
/** 接受响应体信息 */
@property (nonatomic, strong) NSFileHandle *handle;
@property (nonatomic, assign) NSInteger totalSize;
@property (nonatomic, assign) NSInteger currentSize;
@property (nonatomic, strong) NSString *fullPath;
@property (nonatomic, strong)  NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.读取保存的文件总大小的数据,0
    //2.获得当前已经下载的数据的大小
    //3.计算得到进度信息
    
}
-(NSString *)fullPath
{
    if (_fullPath == nil) {
        
        //获得文件全路径
        _fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:FileName];
    }
    return _fullPath;
}

-(NSURLSession *)session
{
    if (_session == nil) {
        //3.创建会话对象,设置代理
        /*
         第一个参数:配置信息 [NSURLSessionConfiguration defaultSessionConfiguration]
         第二个参数:代理
         第三个参数:设置代理方法在哪个线程中调用
         */
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
-(NSURLSessionDataTask *)dataTask
{
    if (_dataTask == nil) {
        //1.url
        NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
        
        //2.创建请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        //3 设置请求头信息,告诉服务器请求那一部分数据
        self.currentSize = [self getFileSize];
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-",self.currentSize];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        //4.创建Task
        _dataTask = [self.session dataTaskWithRequest:request];
    }
    return _dataTask;
}

-(NSInteger)getFileSize
{
    //获得指定文件路径对应文件的数据大小
    NSDictionary *fileInfoDict = [[NSFileManager defaultManager]attributesOfItemAtPath:self.fullPath error:nil];
    NSLog(@"%@",fileInfoDict);
    NSInteger currentSize = [fileInfoDict[@"NSFileSize"] integerValue];
    
    return currentSize;
}
- (IBAction)startBtnClick:(id)sender
{
    [self.dataTask resume];
}

- (IBAction)suspendBtnClick:(id)sender
{
    NSLog(@"_________________________suspend");
    [self.dataTask suspend];
}

//注意:dataTask的取消是不可以恢复的
- (IBAction)cancelBtnClick:(id)sender
{
      NSLog(@"_________________________cancel");
    [self.dataTask cancel];
    self.dataTask = nil;
}

- (IBAction)goOnBtnClick:(id)sender
{
      NSLog(@"_________________________resume");
    [self.dataTask resume];
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
    //expectedContentLength 本次请求的数据大小
    self.totalSize = response.expectedContentLength + self.currentSize;
    
    if (self.currentSize == 0) {
        //创建空的文件
        [[NSFileManager defaultManager]createFileAtPath:self.fullPath contents:nil attributes:nil];
        
    }
    //创建文件句柄
    self.handle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
    
    //移动指针
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

-(void)dealloc
{
    //清理工作
    //finishTasksAndInvalidate
    [self.session invalidateAndCancel];
}

@end
