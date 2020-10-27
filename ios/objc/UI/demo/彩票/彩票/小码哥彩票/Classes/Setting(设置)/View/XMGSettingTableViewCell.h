//
//  XMGSettingTableViewCell.h
//  小码哥彩票
//
//  Created by xiaomage on 16/2/2.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMGSettingItem.h"
#import "XMGSettingGroup.h"
#import "XMGSettingArrowItem.h"
#import "XMGSettingSwitchItem.h"

@interface XMGSettingTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (instancetype)cellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)cellStyle;

/** 行模型 */
@property (nonatomic, strong) XMGSettingItem *item;


@end
