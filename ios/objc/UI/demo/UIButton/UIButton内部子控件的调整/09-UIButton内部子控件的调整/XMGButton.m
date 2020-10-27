//
//  XMGButton.m
//  09-UIButton内部子控件的调整
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGButton.h"

@implementation XMGButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       // 文本居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
       // 改变图片的内容模式
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

#pragma mark - 方式一
/**
 *  重写两个方法: 不要调用super,就是要重写掉
 *  contentRect: 内容的尺寸,内容包括(imageView和label)
 */
/*
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, 100, 70);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(100, 0, 70, 70);
}
  */



#pragma mark - 方式二
- (void)layoutSubviews{
    [super layoutSubviews];
    // 设置子控件的位置
    self.titleLabel.frame = CGRectMake(0, 0, 100, 70);
    self.imageView.frame = CGRectMake(100, 0, 70, 70);
}

@end
