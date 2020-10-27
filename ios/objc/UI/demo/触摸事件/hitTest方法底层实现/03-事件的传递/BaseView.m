//
//  BaseView.m
//  03-事件的传递
//
//  Created by xiaomage on 16/1/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%@-----touch",[self class]);
}


@end
