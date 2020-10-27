//
//  Person.m
//  01-Runtime(消息机制)
//
//  Created by xiaomage on 16/3/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)eat
{
    NSLog(@"吃");
}
- (void)run:(NSInteger)metre
{
    NSLog(@"跑了%ld",metre);
}
@end
