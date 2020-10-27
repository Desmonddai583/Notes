//
//  XMGCar.h
//  备课-11-索引条
//
//  Created by zhc on 15/12/11.
//  Copyright (c) 2015年 FTD. All rights reserved.
//  一个XMGCar就代表一辆车

#import <Foundation/Foundation.h>

@interface XMGCar : NSObject
/**
 *  图标
 */
@property (nonatomic ,copy)NSString * icon;
/**
 *  名称
 */
@property (nonatomic ,copy)NSString * name;


@end
