//
//  ProvinceItem.m
//  03-拦截用户输入
//
//  Created by xiaomage on 16/1/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ProvinceItem.h"

@implementation ProvinceItem

+ (instancetype)itemWithDict:(NSDictionary *)dict{
    
    ProvinceItem *item =  [[ProvinceItem alloc] init];
    [item setValuesForKeysWithDictionary:dict];
    return item;
}

@end
