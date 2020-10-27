//
//  XMGSettingItem.h
//  小码哥彩票
//
//  Created by simplyou on 15/11/13.
//  Copyright © 2015年 simplyou. All rights reserved.
//  行模型

#import <Foundation/Foundation.h>

@interface XMGSettingItem : NSObject
/**
 *  图标
 */
@property (nonatomic, strong) UIImage *image;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  子标题
 */
@property (nonatomic, copy) NSString *subTitle;
/**
 *  点击这行cell要做的事情
 */
@property (nonatomic, strong) void(^operation)(NSIndexPath *indexPath);

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title;

+ (instancetype)itemWithTitle:(NSString *)title;
@end
