//
//  CellItem.m
//  02-block开发使用场景（保存代码）
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "CellItem.h"

@implementation CellItem
+ (instancetype)itemWithTitle:(NSString *)title
{
    CellItem *item = [[self alloc] init];
    
    item.title = title;
    
    return item;
}
@end
