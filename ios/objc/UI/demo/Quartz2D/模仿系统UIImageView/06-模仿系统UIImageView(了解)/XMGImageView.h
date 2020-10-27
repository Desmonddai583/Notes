//
//  XMGImageView.h
//  06-模仿系统UIImageView(了解)
//
//  Created by xiaomage on 16/1/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGImageView : UIView


/** <#注释#> */
@property (nonatomic, strong) UIImage *image;


- (instancetype)initWithImage:(UIImage *)image;

@end
