//
//  XMGTabBar.h
//  小码哥彩票
//
//  Created by xiaomage on 16/1/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGTabBar;

@protocol XMGTabBarDelegate <NSObject>

- (void)tabBar:(XMGTabBar *)tabBar index:(NSInteger)index;

@end

@interface XMGTabBar : UIView


/** 子控制器的个数 */
//@property (nonatomic, assign) NSInteger count;


/** 模型数组 */
@property (nonatomic, strong) NSArray *items;


@property (nonatomic, weak) id<XMGTabBarDelegate> delegate;
@end
