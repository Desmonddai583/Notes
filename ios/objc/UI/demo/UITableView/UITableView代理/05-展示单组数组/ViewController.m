//
//  ViewController.m
//  05-展示单组数组
//
//  Created by xiaomage on 16/1/7.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGWine.h"

@interface ViewController () <UITableViewDataSource ,UITableViewDelegate>
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
    
    // 设置代理
    self.tableView.delegate = self;
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
    
    // 设置选中样式
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 取出indexPath 对应的酒模型
    XMGWine *wine = self.wineArray[indexPath.row];
    
    // 设置数据
    cell.textLabel.text = wine.name;
    cell.imageView.image = [UIImage imageNamed:wine.image];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",wine.money];
    cell.detailTextLabel.textColor = [UIColor orangeColor];
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"头部";
//}

#pragma mark - UITableViewDelegate
/**
 *  选中了某一行cell就会调用这个方法
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中了:%ld",indexPath.row);
}

/**
 *  取消选中了某一行cell就会调用这个方法
 */
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
//     NSLog(@"取消选中了:%ld",indexPath.row);
}

/**
 *  返回每一组显示的头部控件
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIButton buttonWithType:UIButtonTypeContactAdd];
}

/**
 *  返回每一组显示的尾部控件
 */
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    
//}

/**
 *  返回每一组的头部高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

/**
 *  返回每一组的尾部高度
 */
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    
//}

/**
 *  返回每一行cell的高度
 */
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row % 2 == 0) {
//        return 100;
//    } else {
//        return 50;
//    }
//}
@end
