//
//  DrawView.m
//  10-画板
//
//  Created by xiaomage on 16/1/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "DrawView.h"
#import "MyBezierPath.h"

@interface DrawView()

/** 当前绘制的路径 */
@property (nonatomic, strong) UIBezierPath *path;

//保存当前绘制的所有路径
@property (nonatomic, strong) NSMutableArray *allPathArray;

//当前路径的线宽
@property (nonatomic, assign) CGFloat width;

//当前路径的颜色
@property (nonatomic, strong) UIColor *color;

@end

@implementation DrawView


- (NSMutableArray *)allPathArray {
    
    if (_allPathArray == nil) {
        _allPathArray = [NSMutableArray array];
    }
    return _allPathArray;
}


- (void)awakeFromNib {
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    self.width = 1;
    self.color = [UIColor blackColor];
}


-(void)setImage:(UIImage *)image {
    _image = image;
    
    //添加图片添加到数组当中
    [self.allPathArray addObject:image];
    //重绘
    [self setNeedsDisplay];
}


//清屏
- (void)clear {
    //清空所有的路径
    [self.allPathArray removeAllObjects];
    //重绘
    [self setNeedsDisplay];
    
}
//撤销
- (void)undo {
    //删除最后一个路径
    [self.allPathArray removeLastObject];
    //重绘
    [self setNeedsDisplay];
}
//橡皮擦
- (void)erase {
    [self setLineColor:[UIColor whiteColor]];
}

//设置线的宽度
- (void)setLineWith:(CGFloat)lineWidth {
    self.width = lineWidth;
}

//设置线的颜色
- (void)setLineColor:(UIColor *)color {
    self.color = color;
}



- (void)pan:(UIPanGestureRecognizer *)pan {
    
    //获取的当前手指的点
    CGPoint curP = [pan locationInView:self];
    //判断手势的状态
    if(pan.state == UIGestureRecognizerStateBegan) {
        //创建路径
        //UIBezierPath *path = [UIBezierPath bezierPath];
        MyBezierPath *path = [[MyBezierPath alloc] init];
        self.path = path;
        //设置起点
        [path moveToPoint:curP];
        
        //设置线的宽度
        [path setLineWidth:self.width];
        //设置线的颜色
        //什么情况下自定义类:当发现系统原始的功能,没有办法瞒足自己需求时,这个时候,要自定义类.继承系统原来的东西.再去添加属性自己的东西.
        path.color = self.color;
        
        [self.allPathArray addObject:path];
        
    } else if(pan.state == UIGestureRecognizerStateChanged) {
        
        //绘制一根线到当前手指所在的点
        [self.path addLineToPoint:curP];
        //重绘
        [self setNeedsDisplay];
    }
    
}

-(void)drawRect:(CGRect)rect {
    
    //绘制保存的所有路径
    for (MyBezierPath *path in self.allPathArray) {
        //判断取出的路径真实类型
        if([path isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)path;
            [image drawInRect:rect];
        }else {
            [path.color set];
            [path stroke];
        }
      
    }
    
}







@end
