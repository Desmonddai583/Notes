//
//  CellItem.h
//  02-block开发使用场景（保存代码）
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellItem : NSObject

// 设计模型:控件需要展示什么内容,就定义什么属性
@property (nonatomic, strong) NSString *title;

// 保存每个cell做的事情
@property (nonatomic, strong) void(^block)();

+ (instancetype)itemWithTitle:(NSString *)title;

@end
