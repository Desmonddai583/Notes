//
//  ViewController.m
//  08-掌握-小文件下载
//
//  Created by xiaomage on 16/2/25.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>
/** 注释 */
@property (nonatomic, strong) NSMutableData *fileData;
@property (nonatomic, assign) NSInteger totalSize;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

-(NSMutableData *)fileData
{
    if (_fileData == nil) {
        _fileData = [NSMutableData data];
    }
    return _fileData;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self download3];
}

//耗时操作[NSData dataWithContentsOfURL:url]
-(void)download1
{
    //1.url
    NSURL *url = [NSURL URLWithString:@"http://img5.imgtn.bdimg.com/it/u=1915764121,2488815998&fm=21&gp=0.jpg"];
    
    //2.下载二进制数据
   NSData *data = [NSData dataWithContentsOfURL:url];
    
    //3.转换
    UIImage *image = [UIImage imageWithData:data];
}

//1.无法监听进度
//2.内存飙升
-(void)download2
{
    //1.url
   // NSURL *url = [NSURL URLWithString:@"http://imgsrc.baidu.com/forum/w%3D580/sign=54a8cc6f728b4710ce2ffdc4f3cec3b2/d143ad4bd11373f06c0b5bd1a40f4bfbfbed0443.jpg"];

    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       
        //4.转换
//        UIImage *image = [UIImage imageWithData:data];
//        
//        self.imageView.image = image;
        //NSLog(@"%@",connectionError);
        
        //4.写数据到沙盒中
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"123.mp4"];
        [data writeToFile:fullPath atomically:YES];
    }];
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
    
    //得到文件的总大小(本次请求的文件数据的总大小)
    self.totalSize = response.expectedContentLength;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   // NSLog(@"%zd",data.length);
    [self.fileData appendData:data];
    
    //进度=已经下载/文件的总大小
    NSLog(@"%f",1.0 * self.fileData.length /self.totalSize);
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    //4.写数据到沙盒中
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"123.mp4"];
    
    [self.fileData writeToFile:fullPath atomically:YES];
    NSLog(@"%@",fullPath);
}
@end
