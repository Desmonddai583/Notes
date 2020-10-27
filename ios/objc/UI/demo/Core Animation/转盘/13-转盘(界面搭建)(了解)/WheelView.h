//
//  WheelView.h
//  13-转盘(界面搭建)(了解)
//
//  Created by xiaomage on 16/1/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WheelView : UIView

//快速的创建一个转盘
+ (instancetype)wheelView;

//让转盘开始旋转
- (void)rotation;

//让转盘暂停旋转
- (void)stop;

@end
