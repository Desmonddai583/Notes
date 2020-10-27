//
//  XMGSaveTool.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/13.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGSaveTool.h"

@implementation XMGSaveTool

+ (id)objectForKey:(NSString *)defaultName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}
+ (void)setObject:(id)value forKey:(NSString *)defaultName{
#warning 偏好设置不能存储 nil
    // 偏好设置不能存储nil
    if (defaultName) {
        // 保存当前版本
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
        // 立即保存
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
