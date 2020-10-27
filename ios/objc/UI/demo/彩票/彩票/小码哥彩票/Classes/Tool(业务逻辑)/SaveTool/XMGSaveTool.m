//
//  XMGSaveTool.m
//  小码哥彩票
//
//  Created by xiaomage on 14/1/31.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGSaveTool.h"

@implementation XMGSaveTool
+ (nullable id)objectForKey:(NSString *)defaultName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}
+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName{
   
    if (defaultName) {
        // 屏蔽一下外界的sb行为
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
