//
//  FlagItem.m
//  03-拦截用户输入
//
//  Created by xiaomage on 16/1/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FlagItem.h"

@implementation FlagItem


+ (instancetype)itemWithDict:(NSDictionary *)dict{
    
    FlagItem *item = [[FlagItem alloc] init];
    //[item setValuesForKeysWithDictionary:dict];
    //item.icon = [UIImage imageNamed:item.icon];
    //setValuesForKeysWithDictionary实现原理
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [item setValue:obj forKeyPath:key];

    }];
    
    /**
    [item setValue:@"中国" forKeyPath:@"name"];
     setValue:forKeyPath实现原理
     1.先查看有没有对应key值的set方法,如果有set方法,就会调用set方法,给对应的属性赋值
     2.如果没有set方法,去查看有没有跟key值相同并且带有下划线的成员属性.如果有的话,就给带有下划线的成员属性赋值
     3.如果没有跟key值相同并且带有下划线的成员属性,还会去找有没有跟key值相同名称的成员属性.如果有,就给它赋值.
     4.如果没有直接报错.
     */

    return item;
}


-(void)setIcon:(NSString *)icon{
    
   //NSString *imageName = (NSString *)icon;
    _icon =  [UIImage imageNamed:icon];
    
}




@end
