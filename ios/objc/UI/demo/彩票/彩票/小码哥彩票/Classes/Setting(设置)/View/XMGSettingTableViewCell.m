//
//  XMGSettingTableViewCell.m
//  小码哥彩票
//
//  Created by xiaomage on 16/2/2.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGSettingTableViewCell.h"

@implementation XMGSettingTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)cellStyle{
    static NSString *ID = @"cell";
    
    XMGSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[XMGSettingTableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:ID];
    }
    
//    NSString *string = nil;
//    [string sizeWithFont:nil];
    
    return cell;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    return [self cellWithTableView:tableView cellStyle:UITableViewCellStyleValue1];
}
- (void)setItem:(XMGSettingItem *)item{
    _item = item;
   
    // 1.设置数据
    self.imageView.image = item.icon;
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subTitle;
//    self.detailTextLabel.font = []
    
    // 2.设置右侧视图
    [self setupRightView];
}
- (void)setupRightView{
    if ([_item isKindOfClass:[XMGSettingArrowItem class]]) {
        // 右侧视图是箭头
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    }else if ([_item isKindOfClass:[XMGSettingSwitchItem class]]){
        XMGSettingSwitchItem *swItem = (XMGSettingSwitchItem *)_item;
        
        // 右侧视图是开关
        UISwitch *sw = [[UISwitch alloc] init];
        sw.on = swItem.isOn;
        
        self.accessoryView = sw;
    }else{
        
        self.accessoryView = nil;
    }
}
@end
