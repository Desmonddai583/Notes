//
//  VCView.m
//  07-定时器(雪花效果)(掌握)
//
//  Created by xiaomage on 16/1/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "VCView.h"

@implementation VCView

-(void)awakeFromNib {
    
    //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeY) userInfo:nil repeats:YES];
    
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeY)];
    //想要让CADisplayLink让它工作,必须得要把它添加到主运行循环当中.
    //当每一次屏幕刷新的时候就会调用指定的方法(屏幕每一少刷新60)
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    
    //setNeedsDisplay会调用drawRect:,但是它并不是立马调用.只是设了一个标志.当下一次屏幕刷新的时候才去调用drawRect
}




static int _snowY = 0;

- (void)changeY{

    _snowY += 10;
    if (_snowY > [UIScreen mainScreen].bounds.size.height) {
        _snowY = 0;
    }
    //重绘
    [self setNeedsDisplay];
    NSLog(@"%s",__func__);
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIImage *image = [UIImage imageNamed:@"雪花"];
    [image drawAtPoint:CGPointMake(0, _snowY)];
}


@end
