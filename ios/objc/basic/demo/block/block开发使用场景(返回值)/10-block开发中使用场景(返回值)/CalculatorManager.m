//
//  CalculatorManager.m
//  10-block开发中使用场景(返回值)
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "CalculatorManager.h"

@implementation CalculatorManager
- (CalculatorManager *(^)(int))add
{
    return ^(int value){
        _result += value;
        
        return self;
    };
}

- (CalculatorManager *)add:(int)value
{
    _result += value;
    
    return self;
}

@end
