//
//  ViewController.m
//  09-性能优化
//
//  Created by xiaomage on 16/1/7.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

NSString *ID = @"wine";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView 每一行cell的高度
    self.tableView.rowHeight = 100;
    
    // 根据ID 这个标识 注册对应的cell类型 为UITableViewCell(只注册一次)
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 200;
}

/**
 *  每当一个cell进入视野范围内就会调用1次
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    // 1.去缓存池中取是否有可循环利用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 2.设置数据
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行数据",indexPath.row];

    return cell;
}
@end
