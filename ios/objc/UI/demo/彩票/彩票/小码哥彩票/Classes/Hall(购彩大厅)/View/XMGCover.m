//
//  XMGCover.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//
#define XMGKeyWindow [UIApplication sharedApplication].keyWindow

#import "XMGCover.h"

@implementation XMGCover

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (void)show{
    // 1.创建蒙版
    
    XMGCover *cover = [[self alloc] init];
    
    // 2.添加蒙版
    // 蒙版添加到哪里
    // 添加到窗口上面
    [XMGKeyWindow addSubview:cover];
    
    // 3.设置尺寸
    cover.frame = [UIScreen mainScreen].bounds;
    cover.backgroundColor = [UIColor blackColor];
//    cover.alpha = 0.7f;
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
   
    // 父控件透明子控件也透明
    // 4.添加popMenu
//    UIView *popMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [cover addSubview:popMenu];
//    popMenu.backgroundColor = [UIColor yellowColor];
    
}

+ (void)hide{
    // 隐藏蒙版
    for (UIView *view in XMGKeyWindow.subviews) {
        if ([view isKindOfClass:[XMGCover class]]) {
            // 当前类
            [view removeFromSuperview];
            break;
        }
    }
}
@end
