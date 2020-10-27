//
//  XMGDiscoverTableViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGDiscoverTableViewController.h"

@interface XMGDiscoverTableViewController ()

@end

@implementation XMGDiscoverTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@""];
//    
//    [[NSUserDefaults standardUserDefaults] synchronize];
    [XMGSaveTool setObject:@"" forKey:@""];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 刷新talbeView
    [self.tableView reloadData];
    
}
// 当cell将要显示的时候调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 当cell将要显示的时候做动画从右向左的动画
    
    // 1.将cell平移到屏幕外
    cell.transform = CGAffineTransformMakeTranslation(self.view.width, 0);
    
    
    // 2.让cell复位
    [UIView animateWithDuration:0.5 animations:^{
        cell.transform = CGAffineTransformIdentity;
    }];
}
@end
