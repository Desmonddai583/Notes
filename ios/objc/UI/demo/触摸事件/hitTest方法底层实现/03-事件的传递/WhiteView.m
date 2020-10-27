//
//  WhiteView.m
//  03-事件的传递
//
//  Created by xiaomage on 16/1/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "WhiteView.h"

@implementation WhiteView


//作用:去寻找最适合的View
//什么时候调用:当一个事件传递给当前View,就会调用.
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
    return [super hitTest:point withEvent:event];

}


@end
