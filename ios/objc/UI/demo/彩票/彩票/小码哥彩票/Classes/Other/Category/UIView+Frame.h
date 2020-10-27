//
//  UIView+Frame.h
//  小码哥彩票
//
//  Created by xiaomage on 16/1/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

// 在分类中 @property 只会生成get, set方法,并不会生成下划线的成员属性

@property (nonatomic, assign) CGFloat width;


@property (nonatomic, assign) CGFloat height;


@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;



//- (CGFloat)width;

//- (void)setWidth:(CGFloat)width;
//
//- (CGFloat)height;
//
//- (void)setHeight:(CGFloat)height;


@end
