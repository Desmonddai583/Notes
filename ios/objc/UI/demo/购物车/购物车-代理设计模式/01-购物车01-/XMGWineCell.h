//
//  XMGWineCell.h
//  01-购物车01-
//
//  Created by xiaomage on 16/1/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMGWine ,XMGWineCell;
@protocol XMGWineCellDelegate <NSObject>
@optional
- (void)wineCellDidClickPlusButton:(XMGWineCell *)cell;
- (void)wineCellDidClickMinusButton:(XMGWineCell *)cell;

@end

@interface XMGWineCell : UITableViewCell
/** 模型*/
@property (nonatomic, strong) XMGWine *wine;

/** 代理属性*/
@property (nonatomic, weak) id<XMGWineCellDelegate> delegate;

@end

// 解耦