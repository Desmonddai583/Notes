//
//  UIImage+XMG.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/11.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "UIImage+XMG.h"

@implementation UIImage (XMG)
+ (UIImage *)imageWithOriginal:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}
+ (UIImage *)stretchableImageName:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name] ;
    return  [image stretchableImageWithLeftCapWidth:image.size.width * 0.5f topCapHeight:image.size.height * 0.5f];

}
@end
