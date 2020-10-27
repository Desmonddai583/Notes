//
//  ViewController.m
//  06-掌握-中文转码
//
//  Created by xiaomage on 16/2/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark ----------------------
#pragma mark Events
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self post];
}

#pragma mark ----------------------
#pragma mark Methods
-(void)get
{
    
    NSString *urlStr = @"http://120.25.226.186:32812/login2?username=小码哥&pwd=520it&type=JSON";
    
    NSLog(@"转码前: %@",urlStr);
    
    //中文转码处理
    urlStr =  [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSLog(@"转码后: %@",urlStr);
    
    //1.url
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //http://120.25.226.186:32812/login2?username=%E5%B0%8F%E7%A0%81%E5%93%A5&pwd=520it&type=JSON
    
    NSLog(@"url------%@",url);
    
    //2.urlrequest
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.connect
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        
        //容错处理
        if (connectionError) {
            NSLog(@"%@",connectionError);
            return ;
        }
        //4.解析
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];

}

-(void)post
{
    //观察URL中是否有中文,如果有中文则需要转码
    NSString *urlStr = @"http://120.25.226.186:32812/login2";
    
    //username=小码哥&pwd=520it&type=JSON
    //1.url
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //2.urlrequest
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //2.1 post
    request.HTTPMethod = @"POST";
    
    //2.2 body
    request.HTTPBody = [@"username=小码哥&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    
    //3.connect
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        //容错处理
        if (connectionError) {
            NSLog(@"%@",connectionError);
            return ;
        }
        //4.解析
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];

}
@end
