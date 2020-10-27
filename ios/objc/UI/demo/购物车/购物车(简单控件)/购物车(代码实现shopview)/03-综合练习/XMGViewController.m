//
//  XMGViewController.m
//  03-综合练习
//
//  Created by xiaomage on 15/12/28.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGViewController.h"
#import "XMGShop.h"
#import "XMGShopView.h"

@interface XMGViewController ()

// 购物车
@property (weak, nonatomic) IBOutlet UIView *shopCarView;
// 添加按钮
@property (weak, nonatomic) IBOutlet UIButton *addButton;
// 删除按钮
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

/** 数据数组 */
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation XMGViewController
/**
 *  懒加载
 */
- (NSArray *)dataArr{
    if (_dataArr == nil) {
        // 加载数据
        // 1.获取全路径
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"shopData.plist" ofType:nil];
        self.dataArr = [NSArray arrayWithContentsOfFile:dataPath];
        // 字典转模型
        // 创建临时数组
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in _dataArr) {
            // 创建shop对象
            XMGShop *shop = [XMGShop shopWithDict:dict];
            // 把模型装入数组
            [tempArray addObject:shop];
        }
        self.dataArr = tempArray;
    }
    return _dataArr;
}

// 初始化数据
- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  添加到购物车
 *
 *  @param button 按钮
 */
- (IBAction)add:(UIButton *)button {
/***********************1.定义一些常量*****************************/
    // 1.总列数
    NSInteger allCols = 3;
    // 2.商品的宽度 和 高度
    CGFloat width = 80;
    CGFloat height = 100;
    // 3.求出水平间距 和 垂直间距
    CGFloat hMargin = (self.shopCarView.frame.size.width - allCols * width) / (allCols -1);
    CGFloat vMargin = (self.shopCarView.frame.size.height - 2 * height) / 1;
    // 4. 设置索引
    NSInteger index = self.shopCarView.subviews.count;
    // 5.求出x值
    CGFloat x = (hMargin + width) * (index % allCols);
    CGFloat y = (vMargin + height) * (index / allCols);
    
/***********************2.创建一个商品*****************************/
 
    XMGShopView *shopView = [[XMGShopView alloc] initWithShop:self.dataArr[index]];
    shopView.frame = CGRectMake(x, y, width, height);
//    XMGShopView *shopView = [XMGShopView shopViewWithShop:self.dataArr[index]];
//    shopView.frame = CGRectMake(x, y, width, height);
    
    // 设置数据
//    shopView.shop = self.dataArr[index];
    [self.shopCarView addSubview:shopView];
 

/***********************4.设置按钮的状态*****************************/

    button.enabled = (index != 5);
    
    // 5.设置删除按钮的状态
    self.removeButton.enabled = YES;
    
}

/**
 *  从购物车中删除
 *
 *  @param button 按钮
 */
- (IBAction)remove:(UIButton *)button {
    // 1. 删除最后一个商品
    UIView *lastShopView = [self.shopCarView.subviews lastObject];
    [lastShopView removeFromSuperview];
    
    // 3. 设置添加按钮的状态
    self.addButton.enabled = YES;
    
    // 4. 设置删除按钮的状态
    self.removeButton.enabled = (self.shopCarView.subviews.count != 0);
    
}
@end
