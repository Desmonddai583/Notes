//
//  XMGWineCell.h
//  01-购物车01-
//
//  Created by xiaomage on 16/1/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMGWine;
@interface XMGWineCell : UITableViewCell
/** 模型 */
@property (nonatomic, strong) XMGWine *wine;

@end

// 耦合度高
// 解耦