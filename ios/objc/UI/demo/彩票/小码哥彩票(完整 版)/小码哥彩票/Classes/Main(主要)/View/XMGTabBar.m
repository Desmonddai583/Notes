//
//  XMGTabBar.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/10.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGTabBar.h"
#import "XMGTabBarButton.h"

@interface XMGTabBar()
/**
 *  记录上一次选中的按钮
 */
@property (nonatomic, weak) UIButton *seleButton;
@end

@implementation XMGTabBar


- (void)setItems:(NSArray *)items{
    _items = items;
    for (UITabBarItem *item in items) {
        UIButton *button = [[XMGTabBarButton alloc] init];
        [self addSubview:button];
        [button setBackgroundImage:item.image forState:UIControlStateNormal];
        [button setBackgroundImage:item.selectedImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(tabbarOnClick:) forControlEvents:UIControlEventTouchDown];
        
    }
}
// 按钮点击调用的方法
- (void)tabbarOnClick:(UIButton *)button{
    // 1.选中按钮
    // 取消上一次按钮的选中
    self.seleButton.selected = NO;
    // 选中这一次按钮
    button.selected = YES;
    // 记录这一次选中的按钮
    self.seleButton = button;
    
    // 2.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:index:)]) {
        [self.delegate tabBar:self index:button.tag];
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    CGFloat buttonW = self.frame.size.width / self.items.count;
    CGFloat buttonH = self.frame.size.height;
    
    int i = 0;
    
    for (UIButton *button in self.subviews) {
        
        buttonX = buttonW * i;
        button.tag = i;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        if (i == 0){
            button.selected = YES;
            // 记录这次选中的按钮
            self.seleButton = button;
        }
        i++;
    }
}
@end
