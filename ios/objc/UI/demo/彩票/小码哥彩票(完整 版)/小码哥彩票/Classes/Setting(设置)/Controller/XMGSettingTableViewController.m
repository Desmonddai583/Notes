//
//  XMGSettingTableViewController.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/13.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGSettingTableViewController.h"
#import "MBProgressHUD+XMG.h"
#import "XMGPushTableViewController.h"

@interface XMGSettingTableViewController ()

@end

@implementation XMGSettingTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    // 添加第一组
    [self setupGroup0];
    // 添加第二组
    [self setupGroup1];
    // 添加第三组
    [self setupGroup2];
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

/**
 *  第0组
 */
- (void)setupGroup0{
    
    // 第0组
    XMGSettingArrowItem *item = [XMGSettingArrowItem itemWithImage:[UIImage imageNamed:@"RedeemCode"] title:@"使用税换码"];
//    item.desVc = [UIViewController class];
    
    // 循环引用: 你那我我拿着你大家都不能释放
    // block会对代码块里面的强制针强引用
    
//    __weak XMGSettingTableViewController *weakSelf = self;
    // typeof(x) 动态计算x的类型
    
//    int a = 10;
//    typeof(1) b = 10;
//    NSLog(@"b = %d a = %d",b, a);
    __weak typeof(self) weakSelf = self;
    
    item.operation = ^(NSIndexPath *indexPath){
        UIViewController *vc =  [[UIViewController alloc] init];
        vc.title = @"dadfad";
        vc.view.backgroundColor = [UIColor redColor];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    // 创建组模型
    XMGSettingGruop *group = [XMGSettingGruop groupWithItems:@[item]];
    group.headerTitle = @"123";
    group.footTitle = @"qeqrere";
    
    // 添加到总数组中
    [self.groups addObject:group];
}
- (void)setupGroup1{
    
    // 第1组
    XMGSettingArrowItem *item1 = [XMGSettingArrowItem itemWithImage:[UIImage imageNamed:@"MorePush"] title:@"推送和提醒"];
    item1.desVc = [XMGPushTableViewController class];
    
    XMGSettingSwitchItem *item2 = [XMGSettingSwitchItem itemWithImage:[UIImage imageNamed:@"handShake"] title:@"使用摇一摇机选"];
    item2.open = YES;
    
    XMGSettingItem *item3 = [XMGSettingSwitchItem itemWithImage:[UIImage imageNamed:@"sound_Effect"] title:@"声音效果"];
//    item3.type = XMGSettingItemRightTypeSwitch;
   
    XMGSettingItem *item4 = [XMGSettingSwitchItem itemWithImage:[UIImage imageNamed:@"More_LotteryRecommend"] title:@"购彩小助手"];
    // 创建组模型
    XMGSettingGruop *group = [XMGSettingGruop groupWithItems:@[item1, item2, item3, item4]];
    group.headerTitle = @"hah";
    group.footTitle = @"qweeiwieweiie";
    
    // 添加到总数组中
    [self.groups addObject:group];
}
- (void)setupGroup2{
    // 第2组
    XMGSettingItem *item1 = [XMGSettingArrowItem itemWithImage:[UIImage imageNamed:@"RedeemCode"] title:@"检查新版本"];
    item1.operation = ^(NSIndexPath *indexPath){
        [MBProgressHUD showSuccess:@"没有最新版本"];
        
    };
    
    XMGSettingItem *item2 = [XMGSettingArrowItem itemWithImage:[UIImage imageNamed:@"MoreShare"] title:@"分享"];
    
    XMGSettingItem *item3 = [XMGSettingArrowItem itemWithImage:[UIImage imageNamed:@"MoreNetease"] title:@"产品推荐"];
    
    XMGSettingItem *item4 = [XMGSettingArrowItem itemWithImage:[UIImage imageNamed:@"MoreAbout"] title:@"关于"];
    // 创建组模型
    XMGSettingGruop *group = [XMGSettingGruop groupWithItems:@[item1, item2, item3, item4]];
    
    group.headerTitle = @"hah13414";
    group.footTitle = @"qweeiodooddo";
    // 添加到总数组中
    [self.groups addObject:group];
}
@end
