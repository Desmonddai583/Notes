//
//  NSDictionary+Log.m
//  07-掌握-多值参数和中文输出
//
//  Created by xiaomage on 16/2/25.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSDictionary (Log)

//重写系统的方法控制输出
-(NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
//    return @"你大爷是你大姐";
    NSMutableString *string = [NSMutableString string];
    
    //{}
    [string appendString:@"{"];
    
    //拼接key--value
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [string appendFormat:@"%@:",key];
        [string appendFormat:@"%@,",obj];
        
    }];
    [string appendString:@"}"];
    
    //删除逗号
    //从后往前搜索 得到的是搜索到的第一个符号的位置
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        [string deleteCharactersInRange:range];
    }
    
    return string;
}

@end

@implementation NSArray (Log)

//重写系统的方法控制输出
-(NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    //    return @"你大爷是你大姐";
    NSMutableString *string = [NSMutableString string];
    
    //{}
    [string appendString:@"["];
    
    //拼接obj
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [string appendFormat:@"%@,\n",obj];
    }];

    [string appendString:@"]"];
    
    //删除逗号
    //从后往前搜索 得到的是搜索到的第一个符号的位置
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        [string deleteCharactersInRange:range];
    }

    return string;
}

@end