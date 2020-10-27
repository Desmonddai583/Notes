//
//  XMGPageView.h
//  09-分页功能01-
//
//  Created by xiaomage on 16/1/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGPageView : UIView

/** 图片名数据 */
@property (nonatomic, strong) NSArray *imageNames;
+ (instancetype)pageView;
@end
