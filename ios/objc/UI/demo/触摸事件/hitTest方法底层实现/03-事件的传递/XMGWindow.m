//
//  XMGWindow.m
//  03-事件的传递
//
//  Created by xiaomage on 16/1/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGWindow.h"

@implementation XMGWindow


//作用:去寻找最适合的View
//什么时候调用:当一个事件传递给当前View,就会调用.
//返回值:返回的是谁,谁就是最适合的View(就会调用最适合的View的touch方法)
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
   
    //1.判断自己能否接收事件
    if(self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) {
        return nil;
    }
    //2.判断当前点在不在当前View.
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    //3.从后往前遍历自己的子控件.让子控件重复前两步操作,(把事件传递给,让子控件调用hitTest)
    int count = (int)self.subviews.count;
    for (int i = count - 1; i >= 0; i--) {
        //取出每一个子控件
        UIView *chileV =  self.subviews[i];
        //把当前的点转换成子控件从标系上的点.
        CGPoint childP = [self convertPoint:point toView:chileV];
        UIView *fitView = [chileV hitTest:childP withEvent:event];
        //判断有没有找到最适合的View
        if(fitView){
            return fitView;
        }
    }
    
    //4.没有找到比它自己更适合的View.那么它自己就是最适合的View
    return self;
    
}



//作用:判断当前点在不在它调用View,(谁调用pointInside,这个View就是谁)
//什么时候调用:它是在hitTest方法当中调用的.
//注意:point点必须得要跟它方法调用者在同一个坐标系里面
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
    return YES;
}





@end
