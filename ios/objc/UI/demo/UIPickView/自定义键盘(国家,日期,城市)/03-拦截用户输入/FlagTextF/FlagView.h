//
//  FlagView.h
//  03-拦截用户输入
//
//  Created by xiaomage on 16/1/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlagItem;
@interface FlagView : UIView

+ (instancetype)flagView;

/** <#注释#> */
@property (nonatomic, strong)  FlagItem *item;


@end
