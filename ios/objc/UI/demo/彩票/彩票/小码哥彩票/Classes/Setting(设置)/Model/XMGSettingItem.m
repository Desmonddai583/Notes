//
//  XMGSettingItem.m
//  小码哥彩票
//
//  Created by xiaomage on 16/2/2.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGSettingItem.h"

@implementation XMGSettingItem

+ (instancetype)itemWithIcon:(UIImage *)icon title:(NSString *)title{
    XMGSettingItem *item = [[self alloc] init];
    
    item.icon = icon;
    
    item.title = title;
    
    return item;
}
+ (instancetype)itemWithTitle:(NSString *)title{
    return [self itemWithIcon:nil title:title];
    
}
@end
