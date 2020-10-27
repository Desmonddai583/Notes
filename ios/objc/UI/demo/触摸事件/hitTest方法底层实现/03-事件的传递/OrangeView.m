//
//  OrangeView.m
//  03-事件的传递
//
//  Created by xiaomage on 16/1/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "OrangeView.h"

@implementation OrangeView


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"%s",__func__);
    
    return [super hitTest:point withEvent:event];

}


@end
