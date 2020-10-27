//
//  ViewController.m
//  01-掌握-获得文件的MIMEType
//
//  Created by xiaomage on 16/2/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1.发送请求,可以响应头(内部有MIMEType)
    //2.百度
    //3.调用C语言的API
    //4.application/octet-stream 任意的二进制数据类型
    
    //[self getMimeType];
   NSString *mimeType= [self mimeTypeForFileAtPath:@"/Users/xiaomage/Desktop/123.h"];
    NSLog(@"%@",mimeType);
}

-(void)getMimeType
{
    
    //1.url
    NSURL *url = [NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/123.h"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.发送异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       
        //4.获得文件的类型
        NSLog(@"%@",response.MIMEType);
    }];
    
}

- (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}
@end
