//
//  XMGSettingGruop.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/14.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGSettingGruop.h"

@implementation XMGSettingGruop
+ (instancetype)groupWithItems:(NSArray *)items{
    XMGSettingGruop *group = [[XMGSettingGruop alloc] init];
    group.items = items;
    return group;
}
@end
