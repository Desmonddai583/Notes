//
//  VCView.m
//  09-图片上下文的矩阵操作(了解)
//
//  Created by xiaomage on 16/1/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "VCView.h"

@implementation VCView


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 50)];
    
    //平移操作
    CGContextTranslateCTM(ctx, 100, 100);
    //旋转
    CGContextRotateCTM(ctx, M_PI_4);
    //缩放
    CGContextScaleCTM(ctx, 1.5, 1.5);
    
  
    CGContextAddPath(ctx, path.CGPath);
    
    [[UIColor redColor] set];
    CGContextFillPath(ctx);
    
    
}


@end
