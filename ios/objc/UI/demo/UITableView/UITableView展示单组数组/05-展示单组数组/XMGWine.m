//
//  XMGWine.m
//  05-展示单组数组
//
//  Created by xiaomage on 16/1/7.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGWine.h"

@implementation XMGWine

+ (instancetype)wineWithDict:(NSDictionary *)dict
{
    XMGWine *wine = [[self alloc] init];
    [wine setValuesForKeysWithDictionary:dict];
    return wine;
}
@end
