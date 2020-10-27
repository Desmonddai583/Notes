//
//  StatusItem.m
//  05-Runtime(字典转模型KVC实现)
//
//  Created by xiaomage on 16/3/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "StatusItem.h"

@implementation StatusItem

// 模型只保存最重要的数据,导致模型的属性和字典不能一一对应

+ (instancetype)itemWithDict:(NSDictionary *)dict
{
    StatusItem *item = [[self alloc] init];
    
    // KVC:把字典中所有值给模型的属性赋值
    [item setValuesForKeysWithDictionary:dict];
    
    // 拿到每一个模型属性,去字典中取出对应的值,给模型赋值
    // 从字典中取值,不一定要全部取出来
    // MJExtension:字典转模型 runtime:可以把一个模型中所有属性遍历出来
    // MJExtension:封装了很多层
//    item.pic_urls = dict[@"pic_urls"];
//    item.created_at = dict[@"created_at"];
    
    // KVC原理:
    // 1.遍历字典中所有key,去模型中查找有没有对应的属性
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        
        // 2.去模型中查找有没有对应属性 KVC
        // key:source value:来自即刻笔记
        // [item setValue:@"来自即刻笔记" forKey:@"source"]
        [item setValue:value forKey:key];
        
        
    }];
    
    return item;
}


// 重写系统方法? 1.想给系统方法添加额外功能 2.不想要系统方法实现
// 系统找不到就会调用这个方法,报错
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

/*
    [item setValue:@"来自即刻笔记" forKey:@"source"]:
    1.首先去模型中查找有没有setSource,找到,直接调用赋值 [self setSource:@"来自即刻笔记"]
    2.去模型中查找有没有source属性,有,直接访问属性赋值  source = value
    3.去模型中查找有没有_source属性,有,直接访问属性赋值 _source = value
    4.找不到,就会直接报错 setValue:forUndefinedKey:报找不到的错误
 */

@end
