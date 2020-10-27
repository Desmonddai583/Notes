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
@property (weak, nonatomic) IBOutlet UIButton *deletedButton;

@end

@implementation ViewController

- (NSMutableArray *)wineArray
{
    if (!_wineArray) {
        
        _wineArray = [XMGWine mj_objectArrayWithFilename:@"wine.plist"];
    }
    return _wineArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.allowsMultipleSelection = YES;
    
    // 告诉tableView在编辑模式下可以多选
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    self.deletedButton.hidden = YES;
}

#pragma mark - 按钮的点击
- (IBAction)MultipleRemove {
    // 进入编辑模式
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    self.deletedButton.hidden = !self.tableView.isEditing;
}

- (IBAction)remove {
    // 千万不要一边遍历一边删除,因为每删除一个元素,其他元素的索引可能会发生变化
    NSMutableArray *deletedWine = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [deletedWine addObject:self.wineArray[indexPath.row]];
    }
    
    // 修改模型
    [self.wineArray removeObjectsInArray:deletedWine];
    
    // 刷新表格
//    [self.tableView reloadData];
    [self.tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
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
/**
 *  只要实现这个方法,就拥有左滑删除功能
 *  点击左滑出现的Delete按钮 会调用这个
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.wineArray removeObjectAtIndex:indexPath.row];
//    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

/**
 *  修改默认Delete按钮的文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/**
 *  左滑出现什么按钮
 */
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    self.tableView.editing = YES;
//    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
////        [self.tableView reloadData];
////        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
//        // 退出编辑模式
//        self.tableView.editing = NO;
//    }];
//    
//    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        
//        [self.wineArray removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//    }];
//    return @[action1,action];
//}
@end
