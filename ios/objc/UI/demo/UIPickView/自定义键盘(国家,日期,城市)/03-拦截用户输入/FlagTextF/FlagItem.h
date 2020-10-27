//
//  FlagItem.h
//  03-拦截用户输入
//
//  Created by xiaomage on 16/1/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FlagItem : NSObject

/** 名称 */
@property (nonatomic, strong) NSString *name;
/** 图标的名称 */
@property (nonatomic, strong) UIImage *icon;



+ (instancetype)itemWithDict:(NSDictionary *)dict;


@end
