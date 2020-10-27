//
//  ViewController.m
//  06-掌握-NSURLSessionDownloadTask大文件下载（block）
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
    [self download];
}

//优点:不需要担心内存
//缺点:无法监听文件下载进度
-(void)download
{
    //1.url
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/images/minion_03.png"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.创建session
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.创建Task
    /*
     第一个参数:请求对象
     第二个参数:completionHandler 回调
        location:
        response:响应头信息
        error:错误信息
     */
    //该方法内部已经实现了边接受数据边写沙盒(tmp)的操作
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //6.处理数据
        NSLog(@"%@---%@",location,[NSThread currentThread]);
        
        //6.1 拼接文件全路径
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        //6.2 剪切文件
        [[NSFileManager defaultManager]moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
        NSLog(@"%@",fullPath);
    }];
    
    //5.执行Task
    [downloadTask resume];
}

@end
