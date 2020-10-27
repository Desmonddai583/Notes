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
}

#pragma mark - 按钮的点击
- (IBAction)remove {

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
    [self.wineArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

/**
 *  修改默认Delete按钮的文字
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
@end
