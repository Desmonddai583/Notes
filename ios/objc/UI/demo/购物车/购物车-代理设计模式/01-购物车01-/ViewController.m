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

@interface ViewController ()<UITableViewDataSource ,XMGWineCellDelegate ,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 酒数据 */
@property (nonatomic, strong) NSArray *wineArray;

/** 总价*/
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
/** 购买按钮*/
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

/** 购物车对象 */
@property (nonatomic, strong) NSMutableArray *shoppingCar;
@end

@implementation ViewController


- (NSMutableArray *)shoppingCar
{
    if (!_shoppingCar) {
        _shoppingCar = [NSMutableArray array];
    }
    return _shoppingCar;
}

- (NSArray *)wineArray
{
    if (!_wineArray) {
        _wineArray = [XMGWine mj_objectArrayWithFilename:@"wine.plist"];
    }
    return _wineArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - XMGWineCellDelegate
- (void)wineCellDidClickPlusButton:(XMGWineCell *)cell
{
    // 计算总价
    int totalPrice = self.totalPriceLabel.text.intValue + cell.wine.money.intValue;
    // 设置总价
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%d",totalPrice];
    // 购买按钮一定能点击
    self.buyButton.enabled = YES;
    
    // 之前没有添加过,才添加
    if (![self.shoppingCar containsObject:cell.wine]) {
        [self.shoppingCar addObject:cell.wine];
    }
}

- (void)wineCellDidClickMinusButton:(XMGWineCell *)cell
{
    // 计算总价
    int totalPrice = self.totalPriceLabel.text.intValue - cell.wine.money.intValue;
    // 设置总价
    self.totalPriceLabel.text = [NSString stringWithFormat:@"%d",totalPrice];
    // 购买按钮是否能点击
    self.buyButton.enabled = totalPrice > 0;
    // 移除用户不需要在买的酒
    if (cell.wine.count == 0) {
        [self.shoppingCar removeObject:cell.wine];
    }
}

#pragma mark - 按钮的点击
/**
 *  清空购物车
 */
- (IBAction)clear {
    // 修改模型
    for (XMGWine *wine in self.shoppingCar) {
        wine.count = 0;
    }
    
    // 刷新表格
    [self.tableView reloadData];
    
    // 总价清零
    self.totalPriceLabel.text  = @"0";
    
    // 清空购物车
    [self.shoppingCar removeAllObjects];
    
    // 购买按钮不能点击
    self.buyButton.enabled = NO;
}

/**
 *  购买
 */
- (IBAction)buy {
    // 打印购买多少瓶酒
    for (XMGWine *wine in self.shoppingCar) {
        NSLog(@"购买了%d瓶%@",wine.count,wine.name);
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
    // 设置代理
    cell.delegate = self;
    
    return cell;
}

@end
