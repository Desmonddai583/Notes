//
//  ProgressView.m
//  03-下载进度条(重绘)(掌握)
//
//  Created by xiaomage on 16/1/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView


-(void)setProgressValue:(CGFloat)progressValue {
    _progressValue = progressValue;
    
    //注意:drawRect如果是手动调用的话, 它是不会给你创建跟View相关联的上下文.
    //只有系统调用该方法时, 才会创建跟View相关联的上下文.
    //[self drawRect:self.bounds];
    
    //重绘(系统自动帮你调用drawRect:)
    [self setNeedsDisplay];
    
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    //画弧
    //1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //2.描述路径
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    CGFloat radius = rect.size.width * 0.5 - 10;
    CGFloat startA = -M_PI_2;
    CGFloat angle =  self.progressValue *  M_PI * 2;
    CGFloat endA = startA + angle;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    //3.把路径添加到上下文当中
    CGContextAddPath(ctx, path.CGPath);
    //4.把上下文的内容渲染到View的layer上.
    CGContextStrokePath(ctx);
    
}


@end
