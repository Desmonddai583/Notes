//
//  ViewController.m
//  08-掌握-小文件下载
//
//  Created by xiaomage on 16/2/25.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, assign) NSInteger totalSize;
@property (nonatomic, assign) NSInteger currentSize;
/** 文件句柄*/
@property (nonatomic, strong)NSFileHandle *handle;
/** 沙盒路径 */
@property (nonatomic, strong) NSString *fullPath;
@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self download3];
}

//内存飙升
-(void)download3
{
    //1.url
    // NSURL *url = [NSURL URLWithString:@"http://imgsrc.baidu.com/forum/w%3D580/sign=54a8cc6f728b4710ce2ffdc4f3cec3b2/d143ad4bd11373f06c0b5bd1a40f4bfbfbed0443.jpg"];
    
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.发送请求
    [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

#pragma mark ----------------------
#pragma mark NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    
    //1.得到文件的总大小(本次请求的文件数据的总大小)
    self.totalSize = response.expectedContentLength;
    
    //2.写数据到沙盒中
    self.fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"123.mp4"];
    
    //3.创建一个空的文件
    [[NSFileManager defaultManager] createFileAtPath:self.fullPath contents:nil attributes:nil];
    
    //4.创建文件句柄(指针)
    self.handle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //1.移动文件句柄到数据的末尾
    [self.handle seekToEndOfFile];
    
    //2.写数据
    [self.handle writeData:data];
    
    //3.获得进度
    self.currentSize += data.length;
    
    //进度=已经下载/文件的总大小
    NSLog(@"%f",1.0 *  self.currentSize/self.totalSize);
    self.progressView.progress = 1.0 *  self.currentSize/self.totalSize;
    //NSLog(@"%@",self.fullPath);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //1.关闭文件句柄
    [self.handle closeFile];
    self.handle = nil;
    
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"%@",self.fullPath);
}
@end
