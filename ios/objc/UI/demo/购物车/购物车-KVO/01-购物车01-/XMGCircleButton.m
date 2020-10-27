//
//  XMGCircleButton.m
//  01-购物车01-
//
//  Created by xiaomage on 16/1/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGCircleButton.h"

@implementation XMGCircleButton

- (void)awakeFromNib
{
    // 设置边框宽度
    self.layer.borderWidth = 1.0;
    // 设置边框颜色
    self.layer.borderColor = [UIColor redColor].CGColor;
    // 设置圆角半径
    self.layer.cornerRadius = self.frame.size.width * 0.5;
}
@end
