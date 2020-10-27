//
//  WheelBtn.m
//  13-转盘(界面搭建)(了解)
//
//  Created by xiaomage on 16/1/27.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "WheelBtn.h"

@implementation WheelBtn


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
   CGRect rect =  CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height * 0.5);
    
    if (CGRectContainsPoint(rect, point)) {
        //在指定的范围内
        return [super hitTest:point withEvent:event];
    }else {
        return nil;
    }
    
}





//返回当前按钮当中ImageView的位置尺寸
//contentRect:当前按钮的位置尺寸
-(CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat w = 40;
    CGFloat h=  48;
    CGFloat x = (contentRect.size.width - w) * 0.5;
    CGFloat y = 20;
   
   return  CGRectMake(x, y, w, h);
}


//返回当前按钮当中Label的位置尺寸
//-(CGRect)titleRectForContentRect:(CGRect)contentRect {
//
//}



//取消按钮高亮状态下做的事
-(void)setHighlighted:(BOOL)highlighted {
    
}



@end
