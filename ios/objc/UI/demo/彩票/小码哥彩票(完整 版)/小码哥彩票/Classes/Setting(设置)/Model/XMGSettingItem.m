//
//  XMGSettingItem.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/13.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGSettingItem.h"

@implementation XMGSettingItem

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title{
    XMGSettingItem *item = [[self alloc] init];
    item.image = image;
    item.title = title;
    return item;
}
+ (instancetype)itemWithTitle:(NSString *)title{
    return [self itemWithImage:nil title:title];
}
@end
