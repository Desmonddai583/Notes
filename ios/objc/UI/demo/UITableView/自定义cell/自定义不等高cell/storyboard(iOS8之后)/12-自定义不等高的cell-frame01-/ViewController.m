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
    
    // self-sizing(iOS8 以后)
    // 告诉tableView所有cell的真实高度是自动计算的(根据设置的约束)
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 设置估算高度
    self.tableView.estimatedRowHeight = 44;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"status";
    // 访问缓存池
    XMGStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 传递模型数据
    cell.status = self.statuses[indexPath.row];
    return cell;
}


@end
