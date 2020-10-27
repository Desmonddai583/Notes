//
//  UIImage+XMGExtention.h
//  12-图片的拉伸问题
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XMGExtention)
/**
 * 返回一张受保护的图片(被拉伸的)
 */
+ (instancetype)resizableImageWithLocalImageName: (NSString *)localImageName;
@end
