//
//  XMGImage.m
//  02-Runtime(交换方法)
//
//  Created by xiaomage on 16/3/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGImage.h"

@implementation XMGImage

// 重写方法:想给系统的方法添加额外功能
+ (UIImage *)imageNamed:(NSString *)name
{
    // 真正加载图片
    UIImage *image = [super imageNamed:name];
    
    if (image) {
        NSLog(@"加载成功");
    } else {
        NSLog(@"加载失败");
    }
    
    return image;
    
}

@end
