//
//  ViewController.m
//  02-自定义等高的cell-代码-frame01
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGTgCell.h"
#import "XMGTg.h"
#import "MJExtension.h"

@interface ViewController ()

/** 所有的团购数据 */
@property (nonatomic, strong) NSArray *tgs;
@end

@implementation ViewController

- (NSArray *)tgs
{
    if (!_tgs) {
        
//        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tgs.plist" ofType:nil]];
        
//        NSMutableArray *temp = [NSMutableArray array];
//        for (NSDictionary *tgDict in dictArray) {
//            [temp addObject:[XMGTg tgWithDict:tgDict]];
//        }
        
        
        
//        _tgs = [XMGTg mj_objectArrayWithKeyValuesArray:dictArray];
//        _tgs = [XMGTg mj_objectArrayWithFile:[[NSBundle mainBundle] pathForResource:@"tgs.plist" ofType:nil]];
        
        _tgs = [XMGTg mj_objectArrayWithFilename:@"tgs.plist"];
    }
    return _tgs;
}

NSString *ID = @"tg";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 70;
    
    // 根据ID 注册 对应的cell类型 为XMGTgCell
    [self.tableView registerClass:[XMGTgCell class] forCellReuseIdentifier:ID];
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
    
    // 设置数据(传递模型)
    cell.tg = self.tgs[indexPath.row];
    
    return cell;
}

@end
