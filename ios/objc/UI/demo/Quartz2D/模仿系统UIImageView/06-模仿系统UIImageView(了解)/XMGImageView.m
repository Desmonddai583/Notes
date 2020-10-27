//
//  XMGImageView.m
//  06-模仿系统UIImageView(了解)
//
//  Created by xiaomage on 16/1/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGImageView.h"

@implementation XMGImageView



- (instancetype)initWithImage:(UIImage *)image {

    if (self = [super init]) {
        //确定当前ImageView的尺寸大小
        self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        _image = image;
    }
    return self;
}



-(void)setImage:(UIImage *)image {
    _image = image;
    //重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.image drawInRect:rect];
    
}


@end
