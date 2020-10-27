//
//  XMGSaveTool.h
//  小码哥彩票
//
//  Created by xiaomage on 16/1/31.
//  Copyright © 2016年 小码哥. All rights reserved.
//  存储工具类

#import <Foundation/Foundation.h>

@interface XMGSaveTool : NSObject
+ (nullable id)objectForKey:(NSString *)defaultName;

+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName;
@end
