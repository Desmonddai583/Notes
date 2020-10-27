//
//  XMGShopView.h
//  03-综合练习
//
//  Created by xiaomage on 15/12/29.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGShop;

@interface XMGShopView : UIView

/** 商品模型 */
@property (nonatomic, strong) XMGShop *shop;

// 构造方法
- (instancetype)initWithShop: (XMGShop *)shop;
+ (instancetype)shopViewWithShop: (XMGShop *)shop;

@end
