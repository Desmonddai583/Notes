//
//  ViewController.m
//  04-数据刷新-
//
//  Created by xiaomage on 16/1/11.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGWineCell.h"
#import "MJExtension.h"
#import "XMGWine.h"

@interface ViewController ()<UITableViewDataSource ,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 酒数据 */
@property (nonatomic, strong) NSMutableArray *wineArray;

/** 记录用户选中行的索引 */
@property (nonatomic, strong) NSMutableArray *seletedIndexPath;

@end

@implementation ViewController

- (NSMutableArray *)seletedIndexPath
{
    if (!_seletedIndexPath) {
        _seletedIndexPath = [NSMutableArray array];
    }
    return _seletedIndexPath;
}

- (NSMutableArray *)wineArray
{
    if (!_wineArray) {
        
        _wineArray = [XMGWine mj_objectArrayWithFilename:@"wine.plist"];
    }
    return _wineArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 按钮的点击

- (IBAction)remove {
    // 获取要删除的酒模型
//    NSMutableArray *deletedWine = [NSMutableArray array];
//    for (XMGWine *wine in self.wineArray) {
//        if (wine.isCheched) {
//            [deletedWine addObject:wine];
//        }
//    }
//    // 修改模型
//    [self.wineArray removeObjectsInArray:deletedWine];
//    // 刷新表格
//    [self.tableView reloadData];
    
    // 获取要删除的酒模型
    NSMutableArray *deletedWine = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.seletedIndexPath) {
        [deletedWine addObject:self.wineArray[indexPath.row]];
    }
    
    // 删除模型
    [self.wineArray removeObjectsInArray:deletedWine];
    
    // 刷新表格
    [self.tableView deleteRowsAtIndexPaths:self.seletedIndexPath withRowAnimation:UITableViewRowAnimationAutomatic];
    // 清空数组
    [self.seletedIndexPath removeAllObjects];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"wine";
    XMGWineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[XMGWineCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }

    cell.wine = self.wineArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 修改模型
    XMGWine *wine = self.wineArray[indexPath.row];
    if (wine.isCheched) { // 之前是打钩的,取消打钩
        wine.checked = NO;
        [self.seletedIndexPath removeObject:indexPath];
    } else { // 之前不是打钩的,现在打钩
        wine.checked = YES;
        [self.seletedIndexPath addObject:indexPath];
    }
    
    // 刷新表格
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
