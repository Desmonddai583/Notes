//
//  XMGContactItem.m
//  03-通讯录
//
//  Created by xiaomage on 16/1/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGContactItem.h"

@implementation XMGContactItem

+ (instancetype)itemWithName:(NSString *)name phone:(NSString *)phone{
    
    XMGContactItem *item = [[XMGContactItem alloc] init];
    item.name = name;
    item.phone = phone;
    return item;
}



@end
