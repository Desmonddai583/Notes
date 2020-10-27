//
//  UIImage+XMG.h
//  小码哥彩票
//
//  Created by simplyou on 15/11/11.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XMG)
/**
 *  渲染图片
 *
 *  @param name 图片名称
 *
 *  @return 返回没有渲染的图片
 */
+ (UIImage *)imageWithOriginal:(NSString *)name;
/**
 *  拉伸图片
 *
 *  @param name 图片名称
 *
 *  @return 拉伸后的图片
 */
+ (UIImage *)stretchableImageName:(NSString *)name;

@end
