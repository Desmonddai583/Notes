//
//  XMGSettingGroup.h
//  小码哥彩票
//
//  Created by xiaomage on 16/2/2.
//  Copyright © 2016年 小码哥. All rights reserved.
//  组模型描述每一组

#import <Foundation/Foundation.h>

@interface XMGSettingGroup : NSObject

/** 头部标题 */
@property (nonatomic, copy) NSString *headerTitle;

/** 尾部标题 */
@property (nonatomic, copy) NSString *footTitle;

/** 行模型数组 */
@property (nonatomic, strong) NSArray *items;

+ (instancetype)gruopWithItems:(NSArray *)items;

@end
