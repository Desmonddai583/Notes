//
//  XMGDiscoverTableViewController.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/10.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGDiscoverTableViewController.h"

@interface XMGDiscoverTableViewController ()

@end

@implementation XMGDiscoverTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}
// 当cell 将要现实的时候调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.transform = CGAffineTransformMakeTranslation(self.view.width, 0);
    
    [UIView animateWithDuration:0.5f animations:^{
        cell.transform = CGAffineTransformIdentity;
    }];
    
}

@end
