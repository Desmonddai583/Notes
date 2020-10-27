//
//  DrawView.m
//  08-图形上下文栈(熟悉)
//
//  Created by xiaomage on 16/1/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView



- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //2.描述路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(20, 150)];
    [path addLineToPoint:CGPointMake(280, 150)];
    
    //3.把路径添加到上下文当中.
    CGContextAddPath(ctx, path.CGPath);
    
    //保存当前上下文的状态
    CGContextSaveGState(ctx);
    
    //设置上下文的状态
    CGContextSetLineWidth(ctx, 10);
    [[UIColor redColor] set];
    
    CGContextSaveGState(ctx);

    
    //4.把上下文当中的内容渲染View
    CGContextStrokePath(ctx);
    

    
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(150, 20)];
    [path2 addLineToPoint:CGPointMake(150, 280)];
    //把路径添加到上下文当中.
    CGContextAddPath(ctx, path2.CGPath);
    
//    CGContextSetLineWidth(ctx, 1);
//    [[UIColor blackColor] set];
    //从上下文状态栈当中恢复上下文的状态
    CGContextRestoreGState(ctx);
     CGContextRestoreGState(ctx);
    
    //把上下文当中的内容渲染View
    CGContextStrokePath(ctx);
    
    

    
    
    
}


@end
