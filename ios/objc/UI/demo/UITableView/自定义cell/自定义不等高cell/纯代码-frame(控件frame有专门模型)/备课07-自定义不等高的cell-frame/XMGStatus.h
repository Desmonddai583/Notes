//
//  XMGStatus.h
//  备课07-自定义不等高的cell-frame
//
//  Created by FTD_ZHC on 15/9/22.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XMGNameFont [UIFont systemFontOfSize:17]
#define XMGTextFont [UIFont systemFontOfSize:14]

@interface XMGStatus : NSObject
/**
 *  图像
 */
@property (nonatomic ,copy)NSString *icon;
/**
 *  昵称
 */
@property (nonatomic ,copy)NSString *name;
/**
 *  vip
 */
@property (nonatomic ,assign ,getter=isVip)BOOL vip;
/**
 *  内容
 */
@property (nonatomic ,copy)NSString *text;
/**
 *  配图
 */
@property (nonatomic ,copy)NSString *picture;

+ (instancetype)statusWithDict:(NSDictionary *)dict;
@end
