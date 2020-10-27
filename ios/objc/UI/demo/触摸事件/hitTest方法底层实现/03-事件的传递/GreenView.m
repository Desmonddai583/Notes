//
//  GreenView.m
//  03-事件的传递
//
//  Created by xiaomage on 16/1/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "GreenView.h"

@implementation GreenView

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
     NSLog(@"%s",__func__);
    [super hitTest:point withEvent:event];
    return self;
    
}

@end
