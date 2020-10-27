//
//  XMGPushTableViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 16/2/2.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGPushTableViewController.h"
#import "XMGScoreTableViewController.h"
#import "XMGAwardViewController.h"


@interface XMGPushTableViewController ()

@end

@implementation XMGPushTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 第0组
    [self setupGrup0];
    
}
// 第0组
- (void)setupGrup0{
    // 创建行模型

    XMGSettingArrowItem *item = [XMGSettingArrowItem itemWithTitle:@"开奖推送"];
    item.desVC = [XMGAwardViewController class];
    
    XMGSettingArrowItem *item1 = [XMGSettingArrowItem itemWithTitle:@"比分直播"];
    item1.desVC = [XMGScoreTableViewController class];
    
    XMGSettingArrowItem *item2 = [XMGSettingArrowItem itemWithTitle:@"中奖动画"];
    XMGSettingArrowItem *item3 = [XMGSettingArrowItem itemWithTitle:@"购彩大厅"];
    
    // 创建组模型
    XMGSettingGroup *group = [XMGSettingGroup gruopWithItems:@[item, item1, item2, item3]];
    
    // 将行模型数组添加到数组总数
    [self.groups addObject:group];
}
@end
