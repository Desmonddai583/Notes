//
//  CacultorManager.m
//  09-Block开发使用场景(参数使用)
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "CacultorManager.h"

@implementation CacultorManager
- (void)cacultor:(NSInteger (^)(NSInteger))cacultorBlock
{
//    cacultorBlock = ^(NSInteger result){
//        result += 5;
//        result += 6;
//        result *= 2;
//        return result;
//    };
    
    if (cacultorBlock) {
      _result =  cacultorBlock(_result);
    }
}

@end
