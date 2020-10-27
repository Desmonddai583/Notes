//
//  HandleImageView.h
//  10-画板
//
//  Created by xiaomage on 16/1/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HandleImageView;
@protocol handleImageViewDelegate <NSObject>

- (void)handleImageView:(HandleImageView *)handleImageView newImage:(UIImage *)newImage;

@end


@interface HandleImageView : UIView

/** <#注释#> */
@property (nonatomic, strong) UIImage *image;

/** <#注释#> */
@property (nonatomic, weak) id<handleImageViewDelegate> delegate;

@end
