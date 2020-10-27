//
//  ViewController.m
//  01-购物车01-
//
//  Created by xiaomage on 16/1/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGWineCell.h"
#import "MJExtension.h"
#import "XMGWine.h"

@interface ViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 酒数据 */
@property (nonatomic, strong) NSArray *wineArray;

/** 总价*/
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@end

@implementation ViewController

- (NSArray *)wineArray
{
    if (!_wineArray) {
        _wineArray = [XMGWine mj_objectArrayWithFilename:@"wine.plist"];
        for (XMGWine *wine in _wineArray) {
            [wine addObserver:self forKeyPath:@"count" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
        }
    }
    return _wineArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)dealloc {
    for (XMGWine *wine in _wineArray) {
        [wine removeObserver:self forKeyPath:@"count"];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(XMGWine *)wine change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    // NSKeyValueChangeNewKey == @"new"
    int new = [change[NSKeyValueChangeNewKey] intValue];
    // NSKeyValueChangeOldKey == @"old"
    int old = [change[NSKeyValueChangeOldKey] intValue];
    
    if (new > old) { // 数量增加,点击加号
        // 计算总价
        int totalPrice = self.totalPriceLabel.text.intValue + wine.money.intValue;
        // 设置总价
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%d",totalPrice];
        // 购买按钮一定能点击
        self.buyButton.enabled = YES;
        
    } else { // 数量减少,点击减号
        // 计算总价
        int totalPrice = self.totalPriceLabel.text.intValue - wine.money.intValue;
        // 设置总价
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%d",totalPrice];
        // 控制购买按钮是否能点击
        self.buyButton.enabled = (totalPrice > 0);
    }
}

#pragma mark - 按钮的点击
- (IBAction)clear {
    // 修改模型
    for (XMGWine *wine in self.wineArray) {
        wine.count = 0;
    }
    
    // 刷新表格
    [self.tableView reloadData];
    
    // 总价清零
    self.totalPriceLabel.text  = @"0";
    
    // 购买按钮不能点击
    self.buyButton.enabled = NO;
}

- (IBAction)buy {
    // 打印购买多少瓶酒
    for (XMGWine *wine in self.wineArray) {
        if (wine.count) {
            NSLog(@"购买了%d瓶%@",wine.count,wine.name);
        }
    }
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
    // 传递模型
    cell.wine = self.wineArray[indexPath.row];
    return cell;
}

@end
