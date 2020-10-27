//
//  XMGSettingGruop.h
//  小码哥彩票
//
//  Created by simplyou on 15/11/14.
//  Copyright © 2015年 simplyou. All rights reserved.
//  组模型    1.这一组有多行,并且每一行要显示什么东西, 2. 头部标题, 3.尾部标题

#import <Foundation/Foundation.h>

@interface XMGSettingGruop : NSObject
/**
 *  行模型数组
 */
@property (nonatomic, strong) NSArray *items;
/**
 *  头部标题
 */
@property (nonatomic, copy) NSString *headerTitle;
/**
 *  尾部标题
 */
@property (nonatomic, copy) NSString *footTitle;

+ (instancetype)groupWithItems:(NSArray *)items;
@end
