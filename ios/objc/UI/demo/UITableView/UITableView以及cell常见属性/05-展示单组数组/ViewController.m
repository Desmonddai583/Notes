//
//  ViewController.m
//  05-展示单组数组
//
//  Created by xiaomage on 16/1/7.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGWine.h"

@interface ViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 所有的酒数据 */
@property (nonatomic, strong) NSArray *wineArray;
@end

@implementation ViewController

- (NSArray *)wineArray
{
    if (!_wineArray) {
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wine.plist" ofType:nil]];
        
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *wineDict in dictArray) {
            [temp addObject:[XMGWine wineWithDict:wineDict]];
        }
        
        _wineArray = temp;
    }
    return _wineArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置tableView每一行cell的高度
    self.tableView.rowHeight = 100;
    
    // 设置tableView每一组的头部高度
    self.tableView.sectionHeaderHeight = 80;
    // 设置tableView每一组的尾部高度
//    self.tableView.sectionFooterHeight = 80;
    
    // 设置分割线的颜色
//    self.tableView.separatorColor = [UIColor redColor];
    
    // 设置分割线的样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置表头控件
    self.tableView.tableHeaderView = [[UISwitch alloc] init];
    // 设置表尾控件
    self.tableView.tableFooterView = [[UISwitch alloc] init];
}

#pragma mark - UITableViewDataSource

// section == 0
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    // 设置右边显示的指示样式
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 设置右边显示的指示控件
    cell.accessoryView = [[UISwitch alloc] init];
    // 设置选中样式
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 设置cell的背景View
    // backgroundView的优先级 > backgroundColor
//    UIView *bg = [[UIView alloc] init];
//    bg.backgroundColor = [UIColor blueColor];
//    cell.backgroundView = bg;
    
    // 设置cell的背景颜色
//    cell.backgroundColor = [UIColor redColor];
    
    // 设置cell选中时候的背景view
//    UIView *selectedBg = [[UIView alloc] init];
//    selectedBg.backgroundColor = [UIColor greenColor];
//    cell.selectedBackgroundView =  selectedBg;
    
  

    // 取出indexPath 对应的酒模型
    XMGWine *wine = self.wineArray[indexPath.row];
    
    // 设置数据
    cell.textLabel.text = wine.name;
    cell.imageView.image = [UIImage imageNamed:wine.image];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",wine.money];
    cell.detailTextLabel.textColor = [UIColor orangeColor];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"头部";
}
@end
