//
//  XMGScoreViewController.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/15.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGScoreViewController.h"

@interface XMGScoreViewController ()

@end

@implementation XMGScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGroup0];
    
    [self setupGroup1];
    
    [self setupGroup2];
    
    [self setupGroup2];
    
    [self setupGroup2];
    
    [self setupGroup2];
    
    [self setupGroup2];
    
    [self setupGroup2];
}
/**
 *  第0组
 */
- (void)setupGroup0{
    
    // 第0组
    XMGSettingSwitchItem *item = [XMGSettingSwitchItem itemWithTitle:@"关注比赛"];
    XMGSettingGruop *group = [XMGSettingGruop groupWithItems:@[item]];
    group.footTitle = @"dafad";
    
    [self.groups addObject:group];
    
}
/**
 *  第1组
 */
- (void)setupGroup1{
    XMGSettingItem *item = [XMGSettingItem itemWithTitle:@"起始时间"];
    item.subTitle = @"00:00";
    
    XMGSettingGruop *group = [XMGSettingGruop groupWithItems:@[item]];
    
    [self.groups addObject:group];
    
}
/**
 *  第2组
 */
- (void)setupGroup2{
    
    // 第0组
    XMGSettingItem *item = [XMGSettingItem itemWithTitle:@"结束时间"];
    item.subTitle = @"23:61";
   
    __weak typeof(self) weakSelf = self;
    
    // 在iOS7以后只要把TextFiled添加到cell 上就能实现自动计算高度,自动调整cell的位置
    item.operation = ^(NSIndexPath *indexPath){
        // 把 UITextField 添加到cell上
        UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        UITextField *textFiled = [[UITextField alloc] init];
        [textFiled becomeFirstResponder];
        [cell addSubview:textFiled];
    };

    XMGSettingGruop *group = [XMGSettingGruop groupWithItems:@[item]];
    
    [self.groups addObject:group];
    
}
// 当滑动的时候退出键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
