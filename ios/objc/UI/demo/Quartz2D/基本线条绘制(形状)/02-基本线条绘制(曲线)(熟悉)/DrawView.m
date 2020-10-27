//
//  DrawView.m
//  02-基本线条绘制(曲线)(熟悉)
//
//  Created by xiaomage on 16/1/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView




-(void)awakeFromNib{

 
    //画椭圆
    //UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(50, 50, 100, 50)];
    
    //使用UIBezierPath提供的绘图方法进行绘制
    //[path stroke]:1.获取上下文->2.描述路径,3.把路径添加到上下文,4.把上下文的内容渲染View上,只有在drawRect:方法当中才能够获取上下文.在awakeFromNib当获取不到上下文,所以没有办法 进行绘图.
    //[path stroke];
    
}



- (void)drawRect:(CGRect)rect {

    
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(50, 50, 100, 100)];
    //    [path moveToPoint: CGPointMake(50, 250)];
    //    [path addLineToPoint:CGPointMake(250, 250)];
    //
    //    [path setLineWidth:10];
    //[path stroke];
    
    
    
    
    //使用UIBezierPath提供的绘图方法进行绘制
    //画椭圆
    //UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(50, 50, 100, 100)];

    //[[UIColor redColor] set];
    //[path stroke];

    
    //画弧
    //Center:弧所在的圆心
    //radius:圆的半径
    //startAngle:开始角度
    //endAngle:截至角度
    //clockwise: YES:顺时针 NO:逆时针
    
    NSLog(@"%@",NSStringFromCGPoint(self.center));
    
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    CGFloat radius = rect.size.width * 0.5 - 10;
    //不能直接会用self.center ,是因为self.center坐标是相对于它的父控件.
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:-M_PI_2 clockwise:NO];
    
    //添加一根线到圆心
    [path addLineToPoint:center];
    
    //关闭路径closePath:从路径终点连接一根线到路径的起点
    //[path closePath];
    
    [[UIColor redColor] set];
    
    //画扇形
    //fill(填充之前,会自动关闭路径)
    [path fill];

    //[path stroke]:1.获取上下文->2.描述路径,3.把路径添加到上下文,4.把上下文的内容渲染View上

}


//画矩形
- (void)drawRect{

    //1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //2.描述路径
    //画矩形
    //UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(50, 50, 100, 100)];
    //圆角矩形
    //cornerRadius:圆角半径
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 50, 100, 100) cornerRadius:50];
    
    [[UIColor yellowColor] set];
    //3.把路径添加到上下文
    CGContextAddPath(ctx, path.CGPath);
    //4.把上下文的内容渲染View上
    //CGContextStrokePath(ctx);
    CGContextFillPath(ctx);
    
}





@end
