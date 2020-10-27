//
//  XMGScoreTableViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 16/2/2.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGScoreTableViewController.h"

@interface XMGScoreTableViewController ()

@end

@implementation XMGScoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGruop0];
    
    [self setupGruop1];
    
    [self setupGruop2];
    
    [self setupGruop2];
    
    [self setupGruop2];
    
    [self setupGruop2];
    [self setupGruop2];
    
}
// 第0组
- (void)setupGruop0{
    XMGSettingSwitchItem *item = [XMGSettingSwitchItem itemWithTitle:@"关注比赛"];
    XMGSettingGroup *group = [XMGSettingGroup gruopWithItems:@[item]];
    [self.groups addObject:group];
    
    
}
// 第1组
- (void)setupGruop1{
    XMGSettingItem *item = [XMGSettingItem itemWithTitle:@"起始时间"];
    item.subTitle = @"00:00";
    
    XMGSettingGroup *group = [XMGSettingGroup gruopWithItems:@[item]];
    [self.groups addObject:group];
    
}
// 第2组
- (void)setupGruop2{
    XMGSettingItem *item = [XMGSettingItem itemWithTitle:@"结束时间"];
   item.subTitle = @"24:61";
    
//    __weak typeof(self) weakSelf = self;
    
    // 在iOS7以后只要把textField 添加到cell上,键盘处理操作系统帮我们做好
    __unsafe_unretained typeof(self) weakSelf = self;
    item.operationBlock =^(NSIndexPath *indexPath){
        
       UITableViewCell *cell =  [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        
        UITextField *textField = [[UITextField alloc] init];
        [cell addSubview:textField];
        
        [textField becomeFirstResponder];
        
    };
    
    
    XMGSettingGroup *group = [XMGSettingGroup gruopWithItems:@[item]];
    [self.groups addObject:group];
    
}
// 当scrollView 开始滑动的时候调用
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
}
@end
