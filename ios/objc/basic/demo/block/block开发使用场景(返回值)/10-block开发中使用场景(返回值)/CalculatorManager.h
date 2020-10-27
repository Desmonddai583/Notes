//
//  CalculatorManager.h
//  10-block开发中使用场景(返回值)
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorManager : NSObject

@property (nonatomic, assign) int result;

//- (CalculatorManager *)add:(int)value;

- (CalculatorManager *(^)(int))add;

@end
