//
//  ViewController.m
//  04-掌握-AFN序列化
//
//  Created by xiaomage on 16/2/27.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()<NSXMLParserDelegate>

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self httpData2];
}

//返回的是JSON数据
-(void)json
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //http://120.25.226.186:32812/login?username=123&pwd=122&type=JSON
    //
    
    NSDictionary *paramDict = @{
                                @"username":@"520it",
                                @"pwd":@"520it",
                                @"type":@"JSON"
                                };
    //2.发送GET请求
    /*
     第一个参数:请求路径(不包含参数).NSString
     第二个参数:字典(发送给服务器的数据~参数)
     第三个参数:progress 进度回调
     第四个参数:success 成功回调
     task:请求任务
     responseObject:响应体信息(JSON--->OC对象)
     第五个参数:failure 失败回调
     error:错误信息
     响应头:task.response
     */
    [manager GET:@"http://120.25.226.186:32812/login" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@---%@",[responseObject class],responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

//返回的是XML
-(void)xml
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //http://120.25.226.186:32812/login?username=123&pwd=122&type=JSON
    //
    
    //注意:如果返回的是xml数据,那么应该修改AFN的解析方案
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    NSDictionary *paramDict = @{
                                @"type":@"XML"
                                };
    //2.发送GET请求
    /*
     第一个参数:请求路径(不包含参数).NSString
     第二个参数:字典(发送给服务器的数据~参数)
     第三个参数:progress 进度回调
     第四个参数:success 成功回调
        task:请求任务
        responseObject:响应体信息(JSON--->OC对象)
     第五个参数:failure 失败回调
        error:错误信息
     响应头:task.response
     */
    [manager GET:@"http://120.25.226.186:32812/video" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task,NSXMLParser *parser) {
        
        //NSLog(@"%@---%@",[responseObject class],responseObject);
        //NSXMLParser *parser =(NSXMLParser *)responseObject;
        
        //设置代理
        parser.delegate = self;
        
        //开始解析
        [parser parse];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

//返回的二进制数据
-(void)httpData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //注意:如果返回的是xml数据,那么应该修改AFN的解析方案AFXMLParserResponseSerializer
    //注意:如果返回的数据既不是xml也不是json那么应该修改解析方案为:
    //manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.发送GET请求
    [manager GET:@"http://120.25.226.186:32812/resources/images/minion_01.png" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task,id  _Nullable responseObject) {
        NSLog(@"%@-",[responseObject class]);
        
        //UIImage *image = [UIImage imageWithData:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

-(void)httpData2
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //注意:如果返回的是xml数据,那么应该修改AFN的解析方案AFXMLParserResponseSerializer
    //注意:如果返回的数据既不是xml也不是json那么应该修改解析方案为:
    //manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
   
    //告诉AFN能够接受text/html类型的数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //2.发送GET请求
    [manager GET:@"http://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task,id  _Nullable responseObject) {
        NSLog(@"%@-%@",[responseObject class],[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        //UIImage *image = [UIImage imageWithData:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

#pragma mark ----------------------
#pragma mark NSXMLParserDelegate
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    NSLog(@"%@--%@",elementName,attributeDict);
}
@end
