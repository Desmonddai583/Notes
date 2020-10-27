//
//  ViewController.m
//  06-了解-加密相关
//
//  Created by xiaomage on 16/2/27.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Hash.h"

//足够长+足够咸+足够复杂
#define salt @"shdcskjfcbskfnslfhs.kfsfvmsf8348390(*^^6R%@@IJEKHRKWKFGKF"

@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    //(明文+加盐)MD5
    
    NSLog(@"%@",[@"520it" md5String]);
    NSLog(@"%@",[[@"520it" stringByAppendingString:salt] md5String]);
    
    //先加密+乱序
    //cb0fe21bfcc4c2625469d8ec6f3d710d--->12345
    
    NSLog(@"%@",[@"520it" hmacMD5StringWithKey:@"xiaomage"]);
    
//    NSLog(@"%@",[self base64EncodeString:@"A"]);
//    NSLog(@"%@",[self base64DecodeString:@"QQ=="]);
}

//对一个字符串进行base64编码,并且返回
-(NSString *)base64EncodeString:(NSString *)string
{
    //1.先转换为二进制数据
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    //2.对二进制数据进行base64编码,完成之后返回字符串
    return [data base64EncodedStringWithOptions:0];
}

//对base64编码之后的字符串解码,并且返回
-(NSString *)base64DecodeString:(NSString *)string
{
    //注意:该字符串是base64编码后的字符串
    //1.转换为二进制数据(完成了解码的过程)
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
    
    //2.把二进制数据在转换为字符串
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
@end
