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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.rowHeight = 100;
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
    // 0.定义一个重用标识
    static NSString *ID = @"wine";
    // 1.去缓存池中取是否有可循环利用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 2.如果缓存池没有可循环利用的cell,自己创建
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//         NSLog(@"cellForRowAtIndexPath--%zd",indexPath.row);
        
      
    }
    
    // 3.设置数据
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行数据",indexPath.row];
    
    if (indexPath.row % 2 == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
   
     return cell;
}

/*
 UITableViewCell *cell = [[UITableViewCell alloc] init];
 cell.textLabel.text = [NSString stringWithFormat:@"第%ld行数据",indexPath.row];
 */

@end
