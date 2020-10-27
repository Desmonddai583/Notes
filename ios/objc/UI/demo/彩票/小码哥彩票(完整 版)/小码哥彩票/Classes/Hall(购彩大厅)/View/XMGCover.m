//
//  XMGCover.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/11.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGCover.h"

@implementation XMGCover
+ (void)show{
    XMGCover *cover = [[XMGCover alloc] init];
    
    cover.frame = XMGkeyWindow.bounds;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.7f;

    // 添加弹出菜单
//    UIView *popMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    popMenu.backgroundColor = [UIColor yellowColor];
//    [cover addSubview:popMenu];
    
    [XMGkeyWindow addSubview:cover];
}

+ (void)hidden{
    for (UIView *view in XMGkeyWindow.subviews) {
        if ([view isKindOfClass:[XMGCover class]]) {
            [view removeFromSuperview];
            break;
        }
    }
}
@end
