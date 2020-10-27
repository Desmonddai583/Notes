//
//  XMGShopView.h
//  03-综合练习
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGShop;

@interface XMGShopView : UIView
/** 数据模型 */
@property (nonatomic, strong) XMGShop *shop;

// 快速构造方法
+ (instancetype)shopView;
@end
