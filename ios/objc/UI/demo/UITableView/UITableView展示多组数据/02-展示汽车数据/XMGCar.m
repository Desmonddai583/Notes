//
//  XMGCar.m
//  02-展示汽车数据
//
//  Created by xiaomage on 16/1/7.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGCar.h"

@implementation XMGCar

//+ (instancetype)carWithName:(NSString *)name icon:(NSString *)icon
//{
//    XMGCar *car = [[self alloc] init];
//    car.name = name;
//    car.icon = icon;
//    return car;
//}

+ (instancetype)carWithDict:(NSDictionary *)dict
{
    XMGCar *car = [[self alloc] init];
    car.name = dict[@"name"];
    car.icon = dict[@"icon"];
    return car;
}
@end
