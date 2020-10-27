//
//  XMGCarGroup.h
//  备课-11-索引条
//
//  Created by zhc on 15/12/11.
//  Copyright (c) 2015年 FTD. All rights reserved.
//  一个XMGCarGroup对象就代表一组车

#import <Foundation/Foundation.h>

@interface XMGCarGroup : NSObject

/**
 *  这一组所有的车型(XMGCar)
 */
@property(nonatomic ,strong)NSArray *cars;
/**
 *  这一组的头部标题
 */
@property (nonatomic ,copy)NSString * title;


@end
