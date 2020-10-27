//
//  XMGCarGroup.h
//  02-展示汽车数据
//
//  Created by xiaomage on 16/1/7.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGCarGroup : NSObject

/** 头部 */
@property (nonatomic, copy) NSString *header;

/** 尾部 */
@property (nonatomic, copy) NSString *footer;

/** 所有的车(装的是XMGCar模型) */
@property (nonatomic, strong) NSArray *cars;

+ (instancetype)carGroupWithDict:(NSDictionary *)dict;
@end
