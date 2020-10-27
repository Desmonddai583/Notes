//
//  UIImage+image.h
//  02-带有边框的圆形图片裁剪
//
//  Created by xiaomage on 16/1/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (image)

/**
 *  生成一张带有边框的圆形图片
 *
 *  @param borderW     边框宽度
 *  @param borderColor 边框颜色
 *  @param image       要添加边框的图片
 *
 *  @return 生成的带有边框的圆形图片
 */
+ (UIImage *)imageWithBorder:(CGFloat)borderW color:(UIColor *)borderColor image:(UIImage *)image;

@end
