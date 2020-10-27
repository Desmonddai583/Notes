//
//  XMGAPP.m
//  12-掌握-多图下载综合案例-数据展示
//
//  Created by xiaomage on 16/2/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGAPP.h"

@implementation XMGAPP

+(instancetype)appWithDict:(NSDictionary *)dict
{
    XMGAPP *appM = [[XMGAPP alloc]init];
   //KVC
    [appM setValuesForKeysWithDictionary:dict];
    
    return appM;
}
@end
