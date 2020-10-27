//
//  XMGPerson.m
//  13-KVC的使用
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGPerson.h"

@implementation XMGPerson
{
    int _age;
}

- (instancetype)init{
    if (self = [super init]) {
        _age = 8;
    }
    return self;
}

- (void)printAge{
    NSLog(@"age:%d", _age);
}

- (NSString *)description{
    return [NSString stringWithFormat:@"name:%@----money:%.2f", _name, _money];
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        /*
        self.name = dict[@"name"];
        self.money = [dict[@"money"] floatValue];
         */
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)personWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
