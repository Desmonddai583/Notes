//
//  XMGAwardViewController.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/15.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGAwardViewController.h"

@interface XMGAwardViewController ()

@end

@implementation XMGAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGroup0];
}
/**
 *  第0组
 */
- (void)setupGroup0{
    XMGSettingItem *item0 = [XMGSettingSwitchItem itemWithTitle:@"双色球"];
    item0.subTitle = @"每天开奖";
    
    XMGSettingItem *item1 = [XMGSettingSwitchItem itemWithTitle:@"双色球"];
    item1.subTitle = @"每天开奖";
    
    XMGSettingItem *item2 = [XMGSettingSwitchItem itemWithTitle:@"双色球"];
    item2.subTitle = @"每天开奖";
    
    XMGSettingItem *item3 = [XMGSettingSwitchItem itemWithTitle:@"双色球"];
    item3.subTitle = @"每天开奖";
    
    XMGSettingItem *item4 = [XMGSettingSwitchItem itemWithTitle:@"双色球"];
    item4.subTitle = @"每天开奖";
    
    XMGSettingGruop *group = [XMGSettingGruop groupWithItems:@[item0, item1, item2, item3, item4]];
    
    [self.groups addObject:group];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMGSettingTableViewCell *cell = [XMGSettingTableViewCell cellWithTableView:tableView style:UITableViewCellStyleSubtitle];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    
    // 从总数组中取出组模型数组
    XMGSettingGruop *group = self.groups[indexPath.section];
    
    // 从行模型数组中取出行模型
    XMGSettingItem *item = group.items[indexPath.row];
    // 传递模型
    cell.item = item;
    
    return cell;
}
@end
