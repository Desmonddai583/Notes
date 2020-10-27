//
//  XMGShopView.m
//  03-综合练习
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGShopView.h"
#import "XMGShop.h"

@implementation XMGShopView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        // 文本居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 文本颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark - 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    // 1.获取自身的尺寸
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    // 设置子控件的frame
    self.imageView.frame = CGRectMake(0, 0, width, width);
    self.titleLabel.frame = CGRectMake(0, width, width, height - width);
}

#pragma mark - 设置子控件的数据
- (void)setShop:(XMGShop *)shop{
    _shop = shop;
    // 设置子控件的数据
    /*
    self.imageView.image = [UIImage imageNamed:shop.icon];
    self.titleLabel.text = shop.name;
     */
    [self setImage:[UIImage imageNamed:shop.icon] forState:UIControlStateNormal];
    [self setTitle:shop.name forState:UIControlStateNormal];
}

@end
