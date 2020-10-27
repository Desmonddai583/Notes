//
//  DrawView.h
//  10-画板
//
//  Created by xiaomage on 16/1/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

//清屏
- (void)clear;
//撤销
- (void)undo;
//橡皮擦
- (void)erase;
//设置线的宽度
- (void)setLineWith:(CGFloat)lineWidth;
//设置线的颜色
- (void)setLineColor:(UIColor *)color;

/** 要绘制的图片 */
@property (nonatomic, strong) UIImage * image;



@end
