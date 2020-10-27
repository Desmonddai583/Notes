//
//  BlueView.m
//  06-hitTest练习1
//
//  Created by xiaomage on 16/1/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "BlueView.h"

@interface BlueView()

@property(nonatomic, weak) IBOutlet UIButton *btn;

@end

@implementation BlueView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    //NSLog(@"%@",self.btn);
    //return [super hitTest:point withEvent:event];
    //拿到后面的按钮
    //当点在按钮上的时候,才返回按钮,如果不在按钮上.保持系统默认做法
    
    //判断点在不在按钮身上
    //把当前的点转换到按钮身上的坐标系的点
    CGPoint btnP = [self convertPoint:point toView:self.btn];
    if ([self.btn pointInside:btnP withEvent:event]) {
        return self.btn;
    }else{
        return [super hitTest:point withEvent:event];
    }
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
}

@end
