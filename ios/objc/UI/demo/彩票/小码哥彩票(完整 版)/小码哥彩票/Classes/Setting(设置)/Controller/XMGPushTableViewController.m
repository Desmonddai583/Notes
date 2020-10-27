//
//  XMGPushTableViewController.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/14.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGPushTableViewController.h"
#import "XMGScoreViewController.h"
#import "XMGAwardViewController.h"

@interface XMGPushTableViewController ()

@end

@implementation XMGPushTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGroup0];
}
/**
 *  第0组
 */
- (void)setupGroup0{
    
    // 第0组
    XMGSettingArrowItem *item = [XMGSettingArrowItem itemWithTitle:@"开奖推送"];
    item.desVc = [XMGAwardViewController class];
    
    XMGSettingArrowItem *item1 = [XMGSettingArrowItem itemWithTitle:@"比分直播"];
    item1.desVc = [XMGScoreViewController class];
    
    XMGSettingArrowItem *item2 = [XMGSettingArrowItem itemWithTitle:@"中奖动画"];
    
    XMGSettingArrowItem *item3 = [XMGSettingArrowItem itemWithTitle:@"购彩大厅"];
    
    // 创建组模型
    XMGSettingGruop *group = [XMGSettingGruop groupWithItems:@[item, item1, item2, item3]];
    
    // 添加到总数组中
    [self.groups addObject:group];
}
@end
