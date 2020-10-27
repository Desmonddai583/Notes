//
//  XMGWine.h
//  备课-01-购物车
//
//  Created by MJ Lee on 15/7/2.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGWine : NSObject
@property (copy, nonatomic) NSString *money;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *image;


/** 购买数 */
@property (nonatomic, assign) int count;
@end
