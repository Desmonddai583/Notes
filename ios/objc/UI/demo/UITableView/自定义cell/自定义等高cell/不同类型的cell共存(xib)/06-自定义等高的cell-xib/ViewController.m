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
#import "XMGTestCell.h"

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

NSString *tgID = @"tg";
NSString *testID = @"test";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 70;
//    [self.tableView registerClass:[XMGTgCell class] forCellReuseIdentifier:ID];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGTgCell class]) bundle:nil] forCellReuseIdentifier:tgID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGTestCell class]) bundle:nil] forCellReuseIdentifier:testID];
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row % 2 == 0) {
        // 访问缓存池
        XMGTgCell *cell = [tableView dequeueReusableCellWithIdentifier:tgID];
        // 设置数据(传递模型)
        cell.tg = self.tgs[indexPath.row];
          return cell;
    } else {
        XMGTestCell *cell = [tableView dequeueReusableCellWithIdentifier:testID];
        return cell;
    }

}

@end
