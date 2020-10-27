//
//  ClockView.m
//  06-手势解锁
//
//  Created by xiaomage on 16/1/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ClockView.h"

@interface ClockView()

/** 存放的都是当前选中的按钮 */
@property (nonatomic, strong) NSMutableArray *selectBtnArray;

//当前手指所在的点
@property (nonatomic, assign) CGPoint curP;

@end

@implementation ClockView


-(NSMutableArray *)selectBtnArray {
    
    if (_selectBtnArray == nil) {
        _selectBtnArray = [NSMutableArray array];
    }
    return _selectBtnArray;
}

-(void)awakeFromNib {
    
    //搭建界面添加按钮
    [self setUp];
}

//搭建界面添加按钮
- (void)setUp {
    
    for (int i = 0; i < 9; i++) {
        
        //创建按钮
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.userInteractionEnabled = NO;
        
        btn.tag = i;
        
        //设置按钮图片
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        //设置选中状态下的图片
        [btn setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        
        [self addSubview:btn];
        
    }
    

}


//获取当前手指所在的点
- (CGPoint)getCurrentPoint:(NSSet *)touches {
    
    //1.获取当前手指所在的点
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];

}

//给定一个点,判断给定的点在不在按钮身上
//如果在按钮身,返回当前所在的按钮,如果不在,返回nil;
- (UIButton *)btnRectContainsPoint:(CGPoint)point {

    for (UIButton *btn in self.subviews) {
        
        if (CGRectContainsPoint(btn.frame, point)) {
            //让当前按钮成为选中状态
            //btn.selected = YES;
            return btn;
        }
        
    }
    return nil;
}

//手指开始点击
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //当前的手指所在的点在不在按钮上, 如果在,让按钮成为选中状态
    //1.获取当前手指所在的点
    //UITouch *touch = [touches anyObject];
    //CGPoint curP = [touch locationInView:self];
    CGPoint curP = [self getCurrentPoint:touches];
    //2.判断curP在不在按钮身上
    UIButton *btn = [self btnRectContainsPoint:curP];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        //保存当前选中的按钮
        [self.selectBtnArray addObject:btn];
    }
   
    
}

//手指移动时调用
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //当前的手指所在的点在不在按钮上, 如果在,让按钮成为选中状态
    //1.获取当前手指所在的点
    //UITouch *touch = [touches anyObject];
    //CGPoint curP = [touch locationInView:self];
    CGPoint curP = [self getCurrentPoint:touches];
    //记录当前手指所在的点
    self.curP = curP;
    //2.判断curP在不在按钮身上
    UIButton *btn = [self btnRectContainsPoint:curP];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectBtnArray addObject:btn];
    }
    //重绘
    [self setNeedsDisplay];
    
    
}

//手指离开时调用
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    NSMutableString *str = [NSMutableString string];
    //1.取消所有选中的按钮
    for (UIButton *btn in self.selectBtnArray) {
        NSLog(@"%ld",btn.tag);
        btn.selected = NO;
        [str appendFormat:@"%ld",btn.tag];
    }
    //2.清空路径
    [self.selectBtnArray removeAllObjects];
    [self setNeedsDisplay];
    //3.查看当前选中按钮的顺序
    NSLog(@"%@",str);
}


-(void)drawRect:(CGRect)rect {
    
    if (self.selectBtnArray.count) {
        //1.创建路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        //2.取出所有保存的选中的按钮
        for(int i = 0; i < self.selectBtnArray.count; i++) {
            //取出每一个按钮
            UIButton *btn =  self.selectBtnArray[i];
            //判断当前按钮是不是第一个按钮
            if(i == 0) {
                //如果是,设置成路径的起点
                [path moveToPoint:btn.center];
            }else {
                //添加一根线到按钮的中心
                [path addLineToPoint:btn.center];
            }
        }
        
        //添加一根线到当前手指所在的点
        [path  addLineToPoint:self.curP];
        
        
        //设置路径的状态
        [path setLineWidth:10];
        [[UIColor redColor] set];
        [path setLineJoinStyle:kCGLineJoinRound];
        
        //3.绘制路径
        [path stroke];
    }
    
    
}





-(void)layoutSubviews {
    
    [super layoutSubviews];
    //取出每一个按钮,设置按钮的frame.
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat btnWH = 74;
    
    //总共有多少列
    int column = 3;
    CGFloat margin = (self.bounds.size.width - (btnWH * column)) / (column + 1);
    int curC = 0;
    int curR = 0;
    
    for (int i =0; i < self.subviews.count; i++) {
        
        //求当前所在的列
        curC = i % column;
        //当前所在的行
        curR = i / column;
        
        x = margin + (btnWH + margin) * curC;
        y = margin + (btnWH + margin) * curR;
         //取出每一个按钮
        UIButton *btn = self.subviews[i];
        //设置按钮的frame.
        btn.frame = CGRectMake(x, y, btnWH, btnWH);
    }
    
    
}








@end
