//
//  ViewController.m
//  12-自定义不等高的cell-frame01-
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGStatus.h"
#import "MJExtension.h"
#import "XMGStatusCell.h"

@interface ViewController ()

/** 所有的微博数据 */
@property (nonatomic, strong) NSArray *statuses;
@end

@implementation ViewController

- (NSArray *)statuses
{
    if (!_statuses) {
        _statuses = [XMGStatus mj_objectArrayWithFilename:@"statuses.plist"];
    }
    return _statuses;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置估算高度 (减少tableView:heightForRowAtIndexPath:的调用次数)
    self.tableView.estimatedRowHeight = 200;
}

NSString *ID = @"status";

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 访问缓存池
    XMGStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 传递模型数据
    cell.status = self.statuses[indexPath.row];
    return cell;
}

XMGStatusCell *cell;
#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建一个临时的cell(目的:传递indexPath对应这行的模型,布局内部所有的子控件,得到cell的高度)
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    // 传递模型数据
    cell.status = self.statuses[indexPath.row];
    
    return cell.cellHeight;
}
@end
