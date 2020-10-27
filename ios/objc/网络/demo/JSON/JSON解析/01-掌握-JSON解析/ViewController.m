//
//  ViewController.m
//  01-掌握-JSON解析
//
//  Created by xiaomage on 16/2/25.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self test];
}

-(void)jsonToOC
{
    //1.确定url
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login?username=123&pwd=456&type=JSON"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.发送异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //data---->本质上是一个json字符串
        //4.解析数据
        //NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        //JSON--->oc对象 反序列化
        /*
         第一个参数:JSON的二进制数据
         第二个参数:
         第三个参数:错误信息
         */
        /*
         NSJSONReadingMutableContainers = (1UL << 0), 可变字典和数组
         NSJSONReadingMutableLeaves = (1UL << 1),      内部所有的字符串都是可变的 ios7之后又问题  一般不用
         NSJSONReadingAllowFragments = (1UL << 2)   既不是字典也不是数组,则必须使用该枚举值
         */
        
        NSString *strM = @"\"wendingding\"";
        
        //        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        id obj = [NSJSONSerialization JSONObjectWithData:[strM dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"%@---%@",[obj class],obj);
        
    }];

}

//JSON--->OC
-(void)JSONWithOc
{
    //NSString *strM = @"{\"error\":\"用户名不存在\"}";
    //NSString *strM = @"[\"error\",\"用户名不存在\"]";
    //NSString *strM = @"\"wendingding\"";
    //NSString *strM = @"false";
    //NSString *strM = @"true";
    NSString *strM = @"null";
    
    id obj = [NSJSONSerialization JSONObjectWithData:[strM dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:0];
    NSLog(@"%@---%@",[obj class],obj);
    
    /*
     JOSN   OC
     {}     @{}
     []     @[]
     ""     @""
     false  NSNumber 0
     true   NSNumber 1
     null      NSNull为空
     */
    
    //nil
    [NSNull null];   //该方法获得的是一个单粒,表示为空,可以用在字典或者是数组中
    
}

//OC--->json
-(void)OCtojson
{
    NSDictionary *dictM = @{
                            @"name":@"dasheng11",
                            @"age":@3
           };
    
    NSArray *arrayM = @[@"123",@"456"];
    
    //注意:并不是所有的OC对象都能转换为JSON
    /*
     - 最外层必须是 NSArray or NSDictionary
     - 所有的元素必须是 NSString, NSNumber, NSArray, NSDictionary, or NSNull
     - 字典中所有的key都必须是 NSStrings类型的
     - NSNumbers不能死无穷大
     */
    NSString *strM = @"WENIDNGDING";
    
    BOOL isValid = [NSJSONSerialization isValidJSONObject:strM];
    if (!isValid) {
        NSLog(@"%zd",isValid);
        return;
    }
    
    //OC--->json
    /*
     第一个参数:要转换的OC对象
     第二个参数:选项NSJSONWritingPrettyPrinted 排版 美观
     */
    NSData *data = [NSJSONSerialization dataWithJSONObject:strM options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}

-(void)test
{
    NSArray *arrayM = [NSArray arrayWithContentsOfFile:@"/Users/xiaomage/Desktop/课堂共享/11大神班上课资料/05-多线程网络/0225/资料/apps.plist"];
    NSLog(@"%@",arrayM);
    
    //[arrayM writeToFile:@"/Users/xiaomage/Desktop/123.json" atomically:YES];
    
    //OC--->JSON
    NSData *data =  [NSJSONSerialization dataWithJSONObject:arrayM options:NSJSONWritingPrettyPrinted error:0];
    [data writeToFile:@"/Users/xiaomage/Desktop/123.json" atomically:YES];
}
@end
