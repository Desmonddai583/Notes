//
//  XMGAwardViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 16/2/2.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGAwardViewController.h"

@interface XMGAwardViewController ()

@end

@implementation XMGAwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupGroup0];
    
}
- (void)setupGroup0{
    XMGSettingSwitchItem *item = [XMGSettingSwitchItem itemWithTitle:@"双色球"];
    item.subTitle = @"每天开奖";
    
    XMGSettingSwitchItem *item1 = [XMGSettingSwitchItem itemWithTitle:@"双色球"];
    item1.subTitle = @"每天开奖";
    
    XMGSettingSwitchItem *item2 = [XMGSettingSwitchItem itemWithTitle:@"双色球"];
    item2.subTitle = @"每天开奖";
    
    XMGSettingSwitchItem *item3 = [XMGSettingSwitchItem itemWithTitle:@"双色球"];
    item3.subTitle = @"每天开奖";
    
    XMGSettingSwitchItem *item4 = [XMGSettingSwitchItem itemWithTitle:@"双色球"];
    item4.subTitle = @"每天开奖";
    
    XMGSettingGroup *group = [XMGSettingGroup gruopWithItems:@[item, item1, item2, item3, item4]];
    
    [self.groups addObject:group];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // 1.创建cell
//    static NSString *ID = @"cell";
    
//    XMGSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    
//    if (cell == nil) {
//        cell = [[XMGSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
    
    XMGSettingTableViewCell *cell = [XMGSettingTableViewCell cellWithTableView:tableView cellStyle:UITableViewCellStyleSubtitle];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    
    // 设置数据
    // 0.取出行模型数组
    XMGSettingGroup *group = self.groups[indexPath.section];
    
    // 1.取出行模型
    XMGSettingItem *item =  group.items[indexPath.row];
    
    // 2.设置数据
    cell.item = item;
    
    return cell;
}
@end
