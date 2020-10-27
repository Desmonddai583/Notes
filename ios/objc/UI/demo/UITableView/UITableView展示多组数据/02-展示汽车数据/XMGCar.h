//
//  XMGCar.h
//  02-展示汽车数据
//
//  Created by xiaomage on 16/1/7.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGCar : NSObject
/** 名称 */
@property (nonatomic, copy) NSString *name;

/** 图标 */
@property (nonatomic, copy) NSString *icon;

//+ (instancetype)carWithName:(NSString *)name icon:(NSString *)icon;

+ (instancetype)carWithDict:(NSDictionary *)dict;
@end
