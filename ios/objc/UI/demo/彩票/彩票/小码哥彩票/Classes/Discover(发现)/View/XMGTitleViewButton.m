//
//  XMGTitleViewButton.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/30.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTitleViewButton.h"

@implementation XMGTitleViewButton

// 调整子控件的位置
// 调整imageview的位置
//- (CGRect)imageRectForContentRect:(CGRect)contentRect

//调整lable的位置
//- (CGRect)titleRectForContentRect:(CGRect)contentRect

- (void)layoutSubviews{
    [super layoutSubviews];
//    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    
    if (self.imageView.x < self.titleLabel.x) {
        // 第一次
        // 调整子控件的位置
        // 调整lable
        self.titleLabel.x = self.imageView.x;
        // 调整imageview
        self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
    }
    
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    
    
    [self sizeToFit];
    
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    
    [self sizeToFit];
}
@end
