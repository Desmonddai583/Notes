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

NSString *ID = @"status";
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.rowHeight = 250;
    [self.tableView registerClass:[XMGStatusCell class] forCellReuseIdentifier:ID];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath--%zd",indexPath.row);
    // 访问缓存池
    XMGStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 传递模型数据
    cell.status = self.statuses[indexPath.row];
    return cell;
}

#pragma mark - 代理方法
// 得出方案:在这个方法返回之前就要计算cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath--%zd",indexPath.row);
    XMGStatus *status = self.statuses[indexPath.row];
    return status.cellHeight;
}
@end
