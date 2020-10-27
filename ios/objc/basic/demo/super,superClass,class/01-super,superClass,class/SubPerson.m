//
//  SubPerson.m
//  01-super,superClass,class
//
//  Created by xiaomage on 16/3/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "SubPerson.h"

@implementation SubPerson

- (void)test
{
    // self -> SubPerson
    // class:获取当前方法调用者的类
    // superclass:获取当前方法调用者的父类
    
    // super:仅仅是一个编译指示器,就是给编译器看的,不是一个指针
    // 本质:只要编译器看到super这个标志,就会让当前对象去调用父类方法,本质还是当前对象在调用
    
    [super test];
    // SubPerson Person Person NSObject
    // SubPerson Person SubPerson Person ✅
   
}

@end
