//
//  NSObject+Model.h
//  05-Runtime(字典转模型KVC实现)
//
//  Created by xiaomage on 16/3/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
// 字典转模型
@interface NSObject (Model)

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
