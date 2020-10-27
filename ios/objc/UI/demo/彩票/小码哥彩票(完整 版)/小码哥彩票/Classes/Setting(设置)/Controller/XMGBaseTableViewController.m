//
//  XMGBaseTableViewController.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/15.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGBaseTableViewController.h"


@interface XMGBaseTableViewController ()

@end

@implementation XMGBaseTableViewController
- (instancetype)init{
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (NSMutableArray *)groups{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 取出行组型数组
    XMGSettingGruop *group = self.groups[section];
    
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMGSettingTableViewCell *cell = [XMGSettingTableViewCell cellWithTableView:tableView];
    
    // 从总数组中取出组模型数组
    XMGSettingGruop *group = self.groups[indexPath.section];
    
    // 从行模型数组中取出行模型
    XMGSettingItem *item = group.items[indexPath.row];
    // 传递模型
    cell.item = item;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"%@",indexPath);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 点击检查新版本要做一些事情
    //    if (indexPath.section == 2 && indexPath.row == 0) { // 检查新版本
    //        [MBProgressHUD showSuccess:@"没有最新版本"];
    //        return;
    //    }
    
    // 从总数组中取出组模型数组
    XMGSettingGruop *group = self.groups[indexPath.section];
    
    // 从行模型数组中取出行模型
    XMGSettingItem *item = group.items[indexPath.row];
    
    if (item.operation) {
        item.operation(indexPath);
    }else if ([item isKindOfClass:[XMGSettingArrowItem class]]) {
        // 只有剪头模型才具备跳转功能
        XMGSettingArrowItem *arrowItem = (XMGSettingArrowItem *)item;
        
        if (arrowItem.desVc) { // 如果有目标控制器
            // 拿到目标控制器类名 创建目标控制器
            UIViewController *vc = [[arrowItem.desVc alloc] init];
            vc.title = arrowItem.title;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    // 取出组模型
    XMGSettingGruop *group =  self.groups[section];
    return group.headerTitle;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:   (NSInteger)section{
    // 取出组模型
    XMGSettingGruop *group =  self.groups[section];
    return group.footTitle;
}


@end
