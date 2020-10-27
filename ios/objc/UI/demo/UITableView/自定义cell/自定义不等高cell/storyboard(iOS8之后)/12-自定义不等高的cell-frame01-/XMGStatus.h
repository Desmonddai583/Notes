//
//  XMGStatus.h
//  12-自定义不等高的cell-frame01-
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGStatus : NSObject

/** 文字/图片数据***/
/** 图像 */
@property (nonatomic, copy) NSString *icon;

/** 昵称 */
@property (nonatomic, copy) NSString *name;

/** 正文(内容) */
@property (nonatomic, copy) NSString *text;

/** VIP */
@property (nonatomic, assign, getter=isVip) BOOL vip;

/** 配图 */
@property (nonatomic, copy) NSString *picture;

@end
