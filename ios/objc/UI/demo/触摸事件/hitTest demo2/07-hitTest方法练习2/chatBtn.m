//
//  chatBtn.m
//  07-hitTest方法练习2
//
//  Created by xiaomage on 16/1/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "chatBtn.h"

@implementation chatBtn

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.popBtn) {
        //return self.popBtn;
        //判断当前点在不在popBtn身上
        //把当前点转换popBtn身上的点
         CGPoint popBtnP = [self convertPoint:point toView:self.popBtn];
        if ( [self.popBtn pointInside:popBtnP withEvent:event]) {
            return self.popBtn;
        }else{
            return [super hitTest:point withEvent:event];
        }
        
    }else{
      return  [super hitTest:point withEvent:event];
    }

}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //1.获取UITouch
    UITouch *touch = [touches anyObject];
    //2.获取当前手指的点,上一个手指的点
    CGPoint curP = [touch locationInView:self];
    CGPoint preP = [touch previousLocationInView:self];
    //3.计算偏移量
    CGFloat offsetX = curP.x - preP.x;
    CGFloat offsetY = curP.y - preP.y;
    //4.平移
    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
    
}


@end
