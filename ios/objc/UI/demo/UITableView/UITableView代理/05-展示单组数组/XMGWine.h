//
//  XMGWine.h
//  05-展示单组数组
//
//  Created by xiaomage on 16/1/7.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGWine : NSObject
/** 名称 */
@property (nonatomic, copy) NSString *name;

/** 图标 */
@property (nonatomic, copy) NSString *image;

/** 价格 */
@property (nonatomic, copy) NSString *money;

+ (instancetype)wineWithDict:(NSDictionary *)dict;
@end
