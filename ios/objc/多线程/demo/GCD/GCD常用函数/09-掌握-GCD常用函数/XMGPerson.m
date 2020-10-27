//
//  XMGPerson.m
//  09-掌握-GCD常用函数
//
//  Created by xiaomage on 16/2/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGPerson.h"

@implementation XMGPerson

-(NSArray *)books
{
//    if (_books == nil) {
//        _books = @[@"1234",@"56789"];
//    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _books = @[@"1234",@"56789"];
    });
    return _books;
}
@end
