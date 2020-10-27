//
//  XMGSettingGroup.m
//  小码哥彩票
//
//  Created by xiaomage on 16/2/2.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGSettingGroup.h"

@implementation XMGSettingGroup

+ (instancetype)gruopWithItems:(NSArray *)items{
    XMGSettingGroup *gruop = [[self alloc] init];
    
    gruop.items = items;
    
    return gruop;
}
@end
