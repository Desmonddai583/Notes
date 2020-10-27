//
//  XMGShopView.h
//  03-通过xib自定义商品的View
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGShopView : UIView

// 提供set方法
- (void)setIcon: (NSString *)icon;
- (void)setName: (NSString *)name;

// 提供快速创建方法
+ (instancetype)shopView;
@end
