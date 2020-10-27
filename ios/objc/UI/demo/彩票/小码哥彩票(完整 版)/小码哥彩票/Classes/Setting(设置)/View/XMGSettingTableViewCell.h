//
//  XMGSettingTableViewCell.h
//  小码哥彩票
//
//  Created by simplyou on 15/11/14.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMGSettingItem.h"
#import "XMGSettingSwitchItem.h"
#import "XMGSettingArrowItem.h"
#import "XMGSettingGruop.h"

@interface XMGSettingTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style;
/**
 *  航模型
 */
@property (nonatomic, strong) XMGSettingItem *item;
@end
