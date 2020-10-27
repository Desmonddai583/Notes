//
//  XMGSettingTableViewCell.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/14.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGSettingTableViewCell.h"


@implementation XMGSettingTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style{
    static NSString *ID = @"cell";
    
    XMGSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if (cell == nil) {
        cell = [[XMGSettingTableViewCell alloc] initWithStyle:style reuseIdentifier:ID];
    }
    return cell;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    return [self cellWithTableView:tableView style:UITableViewCellStyleValue1];
}
- (void)setItem:(XMGSettingItem *)item{
    _item = item;
    self.imageView.image = item.image;
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subTitle;
    
    [self setupRightView];
}
/**
 *  设置右侧视图
 */
- (void)setupRightView{
    if ([_item isKindOfClass:[XMGSettingArrowItem class]]) { // 剪头
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    }else if ([_item isKindOfClass:[XMGSettingSwitchItem class]]){
        XMGSettingSwitchItem *swItem = (XMGSettingSwitchItem *)_item;
        UISwitch *sw = [[UISwitch alloc] init];
        sw.on = swItem.open;
        
        self.accessoryView = sw;
    }else{
        // 注意, 一定要清空
        self.accessoryView = nil;
    }

}
@end
