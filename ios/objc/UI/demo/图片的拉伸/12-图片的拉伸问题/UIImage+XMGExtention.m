//
//  UIImage+XMGExtention.m
//  12-图片的拉伸问题
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "UIImage+XMGExtention.h"

@implementation UIImage (XMGExtention)

+ (instancetype)resizableImageWithLocalImageName:(NSString *)localImageName{
   // 创建图片对象
    UIImage *image = [UIImage imageNamed:localImageName];
    
    // 获取图片的尺寸
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeiht = image.size.height;
    
    // 返回一张拉伸且受保护的图片
    return [image stretchableImageWithLeftCapWidth:imageWidth * 0.5 topCapHeight:imageHeiht * 0.5 ];
}
@end
