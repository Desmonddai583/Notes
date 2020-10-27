//
//  VCView.m
//  13-粒子效果
//
//  Created by xiaomage on 16/1/27.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "VCView.h"

@interface VCView()

/** 当前绘制的路径 */
@property (nonatomic, strong)  UIBezierPath *path ;


/** 当前 的粒子 */
@property (nonatomic, weak) CALayer *dotLayer;
@end

@implementation VCView

+(Class)layerClass {
    
    return [CAReplicatorLayer class];
}

-(void)awakeFromNib {
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    
    
    //添加粒子
    CALayer *dotLayer = [CALayer layer];
    dotLayer.frame = CGRectMake(-20, 0, 20, 20);
    dotLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:dotLayer];
    self.dotLayer = dotLayer;
    
    
    CAReplicatorLayer *repL = (CAReplicatorLayer *)self.layer;
    repL.instanceCount = 30;
    
    //设置动画 的延时执行时长
    repL.instanceDelay = 0.5;
    
    
    
    //创建路径,设置起点
    UIBezierPath *path = [UIBezierPath bezierPath];
    self.path = path;
    
}



- (void)pan:(UIPanGestureRecognizer *)pan {
    
    //获取当前点
    CGPoint curP = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        [self.path moveToPoint:curP];
        
    }else if(pan.state == UIGestureRecognizerStateChanged) {
        
        //添加一根线到当前的点
        [self.path addLineToPoint:curP];
        //重绘
        [self setNeedsDisplay];
        
    }
    
}


//开始动画
- (void)start {

    CAKeyframeAnimation *anim = [CAKeyframeAnimation  animation];
    anim.keyPath = @"position";
    anim.path = self.path.CGPath;
    anim.repeatCount = MAXFLOAT;
    anim.duration = 5;
    
    [self.dotLayer addAnimation:anim forKey:nil];
    
}

//重绘
- (void)redraw {
    
    //删除动画
    [self.dotLayer removeAllAnimations];
    //删除路径
    [self.path removeAllPoints];
    //重会
    [self setNeedsDisplay];

}




- (void)drawRect:(CGRect)rect {
    //绘制路径
    [self.path stroke];
    
}


@end
