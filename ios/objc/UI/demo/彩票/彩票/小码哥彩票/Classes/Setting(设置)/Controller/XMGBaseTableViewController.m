//
//  XMGBaseTableViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 16/2/2.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGBaseTableViewController.h"

@interface XMGBaseTableViewController ()

@end

@implementation XMGBaseTableViewController
- (NSMutableArray *)groups{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}
- (instancetype)init{
    return [super initWithStyle:UITableViewStyleGrouped];
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 1.取出行模型数组
    //    NSArray *items = self.groups[section];
    XMGSettingGroup *group =  self.groups[section];
    
    
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // 1.创建cell
    XMGSettingTableViewCell *cell  = [XMGSettingTableViewCell cellWithTableView:tableView];
    
    // 设置数据
    // 0.取出行模型数组
    XMGSettingGroup *group = self.groups[indexPath.section];
    
    // 1.取出行模型
    XMGSettingItem *item =  group.items[indexPath.row];
    
    // 2.设置数据
    cell.item = item;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    // 1.取出组模型
    XMGSettingGroup *group =  self.groups[indexPath.section];
    // 2.取出行模型
    XMGSettingItem *item =  group.items[indexPath.row];
    
    // 做事情和跳转只能做一件
    if (item.operationBlock) {
        item.operationBlock(indexPath);
        
    }else if ([item isKindOfClass:[XMGSettingArrowItem class]]) {
        // 只有箭头模型才具备跳转
        // 跳转
        XMGSettingArrowItem *arrowItem = (XMGSettingArrowItem *)item;
        if (arrowItem.desVC) {
            // 如果有目标控制器才跳转
            UIViewController *vc =  [[arrowItem.desVC alloc] init];
            vc.navigationItem.title = item.title;
            //            vc.title = @"";
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    // 1.取出组模型
    XMGSettingGroup *group = self.groups[section];
    
    return group.headerTitle;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    // 1.取出组模型
    XMGSettingGroup *group = self.groups[section];
    
    return group.footTitle;
}

@end
