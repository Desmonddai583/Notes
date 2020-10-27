//
//  XMGCarGroup.m
//  02-展示汽车数据
//
//  Created by xiaomage on 16/1/7.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGCarGroup.h"
#import "XMGCar.h"

@implementation XMGCarGroup

+ (instancetype)carGroupWithDict:(NSDictionary *)dict
{
    XMGCarGroup *group = [[self alloc] init];
//    [group setValuesForKeysWithDictionary:dict];
    group.header = dict[@"header"];
    group.footer = dict[@"footer"];
    
    // 字典数组-> 模型数组
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *carDict in dict[@"cars"]) {
        XMGCar *car = [XMGCar carWithDict:carDict];
        [temp addObject:car];
    }
    group.cars = temp;
    
    return group;
}
@end
