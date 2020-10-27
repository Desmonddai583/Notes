//
//  ViewController.m
//  06-自定义等高的cell-xib
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGTg.h"
#import "MJExtension.h"
#import "XMGTgCell.h"

@interface ViewController ()

/** 所有的团购数据 */
@property (nonatomic, strong) NSArray *tgs;
@end

@implementation ViewController

- (NSArray *)tgs
{
    if (!_tgs) {
        _tgs = [XMGTg mj_objectArrayWithFilename:@"tgs.plist"];
    }
    return _tgs;
}

NSString *ID = @"tg";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 70;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGTgCell class]) bundle:nil] forCellReuseIdentifier:ID];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 访问缓存池
    XMGTgCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMGTgCell class]) owner:nil options:nil] lastObject];
//    }
    
    // 设置数据(传递模型)
    cell.tg = self.tgs[indexPath.row];
    
    return cell;
}

@end
