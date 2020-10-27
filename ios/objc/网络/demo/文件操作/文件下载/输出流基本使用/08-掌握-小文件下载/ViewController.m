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
/** 沙盒路径 */
@property (nonatomic, strong) NSString *fullPath;
/** 连接对象 */
@property (nonatomic, strong) NSURLConnection *connect;
/** 输出流*/
@property (nonatomic, strong) NSOutputStream *stream;
@end

@implementation ViewController


- (IBAction)startBtnClick:(id)sender {
    [self download];
}
- (IBAction)cancelBtnClick:(id)sender {
    [self.connect cancel];
}
- (IBAction)goOnBtnClick:(id)sender {
    [self download];
}

//内存飙升
-(void)download
{
    //1.url
    // NSURL *url = [NSURL URLWithString:@"http://imgsrc.baidu.com/forum/w%3D580/sign=54a8cc6f728b4710ce2ffdc4f3cec3b2/d143ad4bd11373f06c0b5bd1a40f4bfbfbed0443.jpg"];
    
    NSURL *url = [NSURL URLWithString:@"http://www.33lc.com/article/UploadPic/2012-10/2012102514201759594.jpg"];
    
    //2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求头信息,告诉服务器值请求一部分数据range
    /*
     bytes=0-100 
     bytes=-100
     bytes=0- 请求100之后的所有数据
     */
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-",self.currentSize];
    [request setValue:range forHTTPHeaderField:@"Range"];
    NSLog(@"+++++++%@",range);
    
    //3.发送请求
    NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    self.connect = connect;
}

#pragma mark ----------------------
#pragma mark NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    
    //1.得到文件的总大小(本次请求的文件数据的总大小 != 文件的总大小)
    // self.totalSize = response.expectedContentLength + self.currentSize;
    
    if (self.currentSize >0) {
        return;
    }
    
    self.totalSize = response.expectedContentLength;
    
    //2.写数据到沙盒中
    self.fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"123.jpg"];
    
    NSLog(@"%@",self.fullPath);
    //3.创建输出流
//    NSOutputStream
//    NSInputStream
    /*
     第一个参数:文件的路径
     第二个参数:YES 追加
     特点:如果该输出流指向的地址没有文件,那么会自动创建一个空的文件
     */
    NSOutputStream *stream = [[NSOutputStream alloc]initToFileAtPath:self.fullPath append:YES];
    
    //打开输出流
    [stream open];
    self.stream = stream;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //写数据
    [self.stream write:data.bytes maxLength:data.length];
    
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
    
    //关闭流
    [self.stream close];
    self.stream = nil;
    
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"%@",self.fullPath);
}
@end
