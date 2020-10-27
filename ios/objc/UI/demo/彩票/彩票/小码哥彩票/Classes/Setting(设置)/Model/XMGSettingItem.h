//
//  XMGSettingItem.h
//  小码哥彩票
//
//  Created by xiaomage on 16/2/2.
//  Copyright © 2016年 小码哥. All rights reserved.
//  行模型

//typedef enum : NSUInteger {
//    XMGSettingItemRightViewStateNone,
//    XMGSettingItemRightViewStateArrow,
//    XMGSettingItemRightViewStateSwitch,
//    
//} XMGSettingItemRightViewState;

#import <Foundation/Foundation.h>

@interface XMGSettingItem : NSObject

/** 图片 */
@property (nonatomic, strong) UIImage *icon;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 子标题 */
@property (nonatomic, copy) NSString *subTitle;

/** 点击这一行要做的事情 */
@property (nonatomic, copy) void(^operationBlock)(NSIndexPath *indexPath);


+ (instancetype)itemWithIcon:(UIImage *)icon title:(NSString *)title;

+ (instancetype)itemWithTitle:(NSString *)title;


@end
