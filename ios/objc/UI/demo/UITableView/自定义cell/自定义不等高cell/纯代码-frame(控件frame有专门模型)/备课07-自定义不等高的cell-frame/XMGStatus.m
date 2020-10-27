//
//  XMGStatus.m
//  备课07-自定义不等高的cell-frame
//
//  Created by FTD_ZHC on 15/9/22.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGStatus.h"

@implementation XMGStatus

+ (instancetype)statusWithDict:(NSDictionary *)dict
{
    XMGStatus *status = [[self alloc] init];
    [status setValuesForKeysWithDictionary:dict];
    return status;
}
@end
