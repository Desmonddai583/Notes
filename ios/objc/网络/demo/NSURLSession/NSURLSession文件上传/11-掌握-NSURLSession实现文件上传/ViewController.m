//
//  ViewController.m
//  11-掌握-NSURLSession实现文件上传
//
//  Created by xiaomage on 16/2/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
//                  ----WebKitFormBoundaryvMI3CAV0sGUtL8tr
#define Kboundary @"----WebKitFormBoundaryjv0UfA04ED44AhWx"

#define KNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]

@interface ViewController ()<NSURLSessionDataDelegate>
/** 注释 */
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation ViewController

-(NSURLSession *)session
{
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        //是否运行蜂窝访问
        config.allowsCellularAccess = YES;
        config.timeoutIntervalForRequest = 15;
        
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self upload2];
}

-(void)upload
{
    //1.url
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/upload"];
    
    //2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //2.1 设置请求方法
    request.HTTPMethod = @"POST";

    //2.2 设请求头信息
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Kboundary] forHTTPHeaderField:@"Content-Type"];
    
    //3.创建会话对象
//    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.创建上传TASK
    /*
     第一个参数:请求对象
     第二个参数:传递是要上传的数据(请求体)
     第三个参数:
     */
   NSURLSessionUploadTask *uploadTask = [self.session uploadTaskWithRequest:request fromData:[self getBodyData] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
       //6.解析
       NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    //5.执行Task
    [uploadTask resume];
}

-(void)upload2
{
    //1.url
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/upload"];
    
    //2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //2.1 设置请求方法
    request.HTTPMethod = @"POST";
    
    //2.2 设请求头信息
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Kboundary] forHTTPHeaderField:@"Content-Type"];
    
    //3.创建会话对象
    
    //4.创建上传TASK
    /*
     第一个参数:请求对象
     第二个参数:传递是要上传的数据(请求体)
     */
    NSURLSessionUploadTask *uploadTask = [self.session uploadTaskWithRequest:request fromData:[self getBodyData] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //6.解析
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    //5.执行Task
    [uploadTask resume];
}

-(NSData *)getBodyData
{
    NSMutableData *fileData = [NSMutableData data];
    //5.1 文件参数
    /*
     --分隔符
     Content-Disposition: form-data; name="file"; filename="Snip20160225_341.png"
     Content-Type: image/png(MIMEType:大类型/小类型)
     空行
     文件参数
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    
    //name:file 服务器规定的参数
    //filename:Snip20160225_341.png 文件保存到服务器上面的名称
    //Content-Type:文件的类型
    [fileData appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"Sss.png\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:[@"Content-Type: image/png" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:KNewLine];
    
    UIImage *image = [UIImage imageNamed:@"Snip20160226_90"];
    //UIImage --->NSData
    NSData *imageData = UIImagePNGRepresentation(image);
    [fileData appendData:imageData];
    [fileData appendData:KNewLine];
    
    //5.2 非文件参数
    /*
     --分隔符
     Content-Disposition: form-data; name="username"
     空行
     123456
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:[@"Content-Disposition: form-data; name=\"username\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:KNewLine];
    [fileData appendData:[@"123456" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    
    //5.3 结尾标识
    /*
     --分隔符--
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@--",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return fileData;
}

#pragma mark ----------------------
#pragma mark NSURLSessionDataDelegate
/*
 *  @param bytesSent                本次发送的数据
 *  @param totalBytesSent           上传完成的数据大小
 *  @param totalBytesExpectedToSend 文件的总大小
 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"%f",1.0 *totalBytesSent / totalBytesExpectedToSend);
}
@end
