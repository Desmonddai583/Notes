//
//  XMGSettingTableViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 16/2/2.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGSettingTableViewController.h"
#import "XMGPushTableViewController.h"
#import "MBProgressHUD+XMG.h"

@interface XMGSettingTableViewController ()


@end

@implementation XMGSettingTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"设置";
    self.title = @"设置";
    
    
    // 第0组
    [self setupGrup0];
    
    // 第1组
    [self setupGrup1];

    // 第2组
    [self setupGrup2];
}
// 第0组
- (void)setupGrup0{
    // 创建行模型
    NSMutableArray *items1 = [NSMutableArray array];
    
    XMGSettingArrowItem *item = [XMGSettingArrowItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"使用税换码"];
    [items1 addObject:item];
    item.desVC = [UIViewController class];
    
    // 创建组模型
    XMGSettingGroup *group = [XMGSettingGroup gruopWithItems:items1];
    group.headerTitle = @"123`32324";
//    group.footTitle = @"xxoo----";
    
    // 将行模型数组添加到数组总数
    [self.groups addObject:group];
}
- (void)dealloc{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
}
// 第1组
- (void)setupGrup1{
    // 创建行模型
    XMGSettingArrowItem *item11 = [XMGSettingArrowItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"推送和提醒"];
    item11.desVC = [XMGPushTableViewController class];

    // block 防止循环应用
    // 你拥有我,我有用你
    // block 会对代码块里面的强制针强引用
    
//    __strong
//    __weak XMGSettingTableViewController *weakSelf = self;
    
    // typeof(x) 动态根据x判断x的真实类型
    
//    int a = 10;
//    typeof(1) b = 10;
//    
//    NSLog(@"a %d b %d",a, b);
    
//    __weak typeof(self) weakSelf = self;
//     item11.operationBlock = ^{
////        UIViewController *vc = [[UIViewController alloc] init];
////        vc.title = @"dadfafd";
////        vc.view.backgroundColor = [UIColor yellowColor];
////        [weakSelf.navigationController pushViewController:vc animated:YES];
//        
//        // self -> _gruops
//        // 在block中如果访问下划线的成员属性,会造成循环应用
//        NSLog(@"%@",weakSelf.groups);
//        
//    };
    
    
    XMGSettingSwitchItem *item12 = [XMGSettingSwitchItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"使用税换码"];
    item12.on = YES;
    
    
    XMGSettingSwitchItem *item13 = [XMGSettingSwitchItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"使用税换码"];
    item13.on = YES;
    
    XMGSettingItem *item14 = [XMGSettingSwitchItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"使用税换码"];
   
    NSArray *items2 = @[item11, item12, item13, item14];
    
    // 创建组模型
    XMGSettingGroup *group = [XMGSettingGroup gruopWithItems:items2];
    group.headerTitle = @"hahadfdfd";
    group.footTitle = @"dafdaf";
    
    // 将行模型数组添加到数组总数
    [self.groups addObject:group];
}
// 第2组
- (void)setupGrup2{
    // 创建行模型
    XMGSettingItem *item21 = [XMGSettingArrowItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"检查版本更新"];
    
    item21.operationBlock = ^(NSIndexPath *indexPath){
        // 弹框
        [MBProgressHUD showSuccess:@"没有版本更新"];
    };
    
    XMGSettingItem *item22 = [XMGSettingArrowItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"使用税换码"];
//    item22.operationBlock = ^{
//        // 弹框
//        [MBProgressHUD showSuccess:@"没有版本更新xxoo"];
//    };
    
    XMGSettingItem *item23 = [XMGSettingArrowItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"使用税换码"];
    
    XMGSettingItem *item24 = [XMGSettingArrowItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"使用税换码"];
    NSArray *items3 = @[item21, item22, item23, item24];
    
    // 创建组模型
    XMGSettingGroup *group = [XMGSettingGroup gruopWithItems:items3];
    group.headerTitle = @"hahadf00999dfd";
    group.footTitle = @"dafdaf000d0d";
    
    // 将行模型数组添加到数组总数
    [self.groups addObject:group];
}
@end
