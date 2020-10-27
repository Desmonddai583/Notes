//
//  XMGTabBar.h
//  小码哥彩票
//
//  Created by simplyou on 15/11/10.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGTabBar;

@protocol  XMGTabBarDelegate <NSObject>
// 点击哪个按钮
- (void)tabBar:(XMGTabBar *)tabBar index:(NSInteger)index;

@end

@interface XMGTabBar : UIView
/**
 *  子控件items个数
 */
@property (nonatomic, strong) NSArray *items;

//@property (nonatomic, weak) XMGTabBarViewController *tabBarVc;


@property (nonatomic, weak) id<XMGTabBarDelegate> delegate;
@end
