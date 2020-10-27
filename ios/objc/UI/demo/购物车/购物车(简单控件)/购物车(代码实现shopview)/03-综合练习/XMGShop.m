//
//  XMGShop.m
//  03-综合练习
//
//  Created by xiaomage on 15/12/29.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGShop.h"

@implementation XMGShop
/*
- (instancetype)initWithIcon:(NSString *)icon name:(NSString *)name{
    if (self = [super init]) {
        self.icon = icon;
        self.name = name;
    }
    return self;
}

+ (instancetype)shopWithIcon:(NSString *)icon name:(NSString *)name{
    return [[self alloc] initWithIcon:icon name:name];
}
 */

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.icon = dict[@"icon"];
        self.name = dict[@"name"];
    }
    return self;
}

+ (instancetype)shopWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end
