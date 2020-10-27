//
//  PieView.m
//  04-饼图
//
//  Created by xiaomage on 16/1/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "PieView.h"

@implementation PieView



- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    NSArray *dataArray = @[@25,@25,@50];
    CGPoint center =  CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat radius = self.bounds.size.width * 0.5 - 10;
    CGFloat startA = 0;
    CGFloat angle = 0;
    CGFloat endA = 0;
    
    for (NSNumber *num in dataArray) {
        
        startA = endA;
        angle = num.intValue / 100.0 * M_PI * 2;
        endA = startA + angle;
        UIBezierPath  *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
        [[self randomColor] set];
        //添加一根线到圆心
        [path addLineToPoint:center];
        [path fill];
    }
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //重绘
    [self setNeedsDisplay];
}


//生成一个随机的颜色
- (UIColor *)randomColor {
    
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    
   return  [UIColor colorWithRed:r green:g blue:b alpha:1];
}





- (void)drawPie{
    //画第一个扇形
    CGPoint center =  CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat radius = self.bounds.size.width * 0.5 - 10;
    CGFloat startA = 0;
    CGFloat angle = 25 / 100.0 * M_PI * 2;
    CGFloat endA = startA + angle;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    [[UIColor redColor] set];
    //添加一根线到圆心
    [path addLineToPoint:center];
    [path fill];
    
    //画第二个扇形
    
    startA = endA;
    angle = 25 / 100.0 * M_PI * 2;
    endA = startA + angle;
    path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    [[UIColor greenColor] set];
    //添加一根线到圆心
    [path addLineToPoint:center];
    [path fill];
    
    
    startA = endA;
    angle = 50 / 100.0 * M_PI * 2;
    endA = startA + angle;
    path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    [[UIColor blueColor] set];
    //添加一根线到圆心
    [path addLineToPoint:center];
    [path fill];

}


@end
