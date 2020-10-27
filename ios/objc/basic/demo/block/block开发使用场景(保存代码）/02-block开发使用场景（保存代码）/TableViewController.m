//
//  TableViewController.m
//  02-block开发使用场景（保存代码）
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "TableViewController.h"
#import "CellItem.h"
// 1.tableView展示3个cell,打电话,发短信,发邮件
@interface TableViewController ()
/** 注释 */
@property (nonatomic, strong) NSArray *items;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建模型
    CellItem *item1 = [CellItem itemWithTitle:@"打电话"];
    item1.block = ^{
        NSLog(@"打电话");
    };
    CellItem *item2 = [CellItem itemWithTitle:@"发短信"];
    item2.block = ^{
        NSLog(@"发短信");
    };
    CellItem *item3 = [CellItem itemWithTitle:@"发邮件"];
    item3.block = ^{
        NSLog(@"发邮件");
    };
    _items = @[item1,item2,item3];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    
    // 1.从缓存池取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    CellItem *item = self.items[indexPath.row];
    cell.textLabel.text = item.title;
    
    return cell;
}

// 点击cell就会调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 把要做的事情(代码)保存到模型

    CellItem *item = self.items[indexPath.row];
    
    if (item.block) {
        item.block();
    }
    
//    if (indexPath.row == 0) {
//        // 打电话
//    } else if (indexPath.row == 1) {
//        // 发短信
//    } else if (indexPath.row == 2) {
//        // 发邮件
//    }

    
    
}


@end
