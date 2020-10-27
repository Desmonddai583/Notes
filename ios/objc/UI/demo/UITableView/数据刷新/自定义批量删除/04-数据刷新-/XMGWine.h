//
//  XMGWine.h
//  04-展示单组数据
//
//  Created by sugar on 15/8/26.
//  Copyright (c) 2015年 xulicelg.163. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGWine : NSObject
/**
 *  图标
 */
@property (nonatomic ,copy)NSString *image;

/**
 *  价格
 */
@property (nonatomic ,copy)NSString *money;

/**
 *  名字
 */
@property (nonatomic ,copy)NSString *name;

/** 记录打钩控件的状态 */
@property (nonatomic, assign, getter=isCheched) BOOL checked;
@end
