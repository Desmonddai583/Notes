//
//  XMGButton.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/12.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGButton.h"

@implementation XMGButton

//// 设置Label 的尺寸及位置
//- (CGRect)titleRectForContentRect:(CGRect)contentRect{
//    
//}
//// 设置imageView 的尺寸及位置
//- (CGRect)imageRectForContentRect:(CGRect)contentRect{
//    
//}


// 调整所有子控件的位置
- (void)layoutSubviews{
    [super layoutSubviews];
//    NSLog(@"%s",__func__);
    
    if (self.imageView.x < self.titleLabel.x) { // 第一次调整两个控件的位置
        // 这个方法调用了两次,这个位置调整了两次
        // 1.调整label的位置
        self.titleLabel.x = self.imageView.x;
        // 2.调整imageView的位置
        self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    // 做完自己的事情之后 还原系统原有的方法
    [super setTitle:title forState:state];
    // 增加自己的方法
    // 自动计算尺寸
    [self sizeToFit];
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    
    [self sizeToFit];
}
@end
