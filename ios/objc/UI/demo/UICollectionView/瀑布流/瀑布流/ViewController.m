//
//  ViewController.m
//  瀑布流
//
//  Created by yz on 15/11/25.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "ViewController.h"

#import "WaterFlowLayout.h"

#import "ShopCell.h"

/*
    1.分析瀑布流
    2.等宽不等高才是瀑布流,等高等宽九宫格布局。
    3.循环利用，可以使用UICollectionView
    4.自定义布局
    5.布局方式，九宫格是按照顺序一个一个布局，瀑布流不是，需要自行判断，添加在哪列，因为按照顺序会导致有的列太高，有的列太矮，分布不均匀，应该是哪列最矮，放哪列。
 
 */


static NSString * const ID = @"cell";

@interface ViewController ()<UICollectionViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 添加collectionView
    [self addCollectionView];
    
}

- (void)addCollectionView
{
    
    // 创建流水布局
    WaterFlowLayout *flowLayout = [[WaterFlowLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    
    collectionView.backgroundColor = [UIColor greenColor];
    
    collectionView.dataSource = self;
    
    [self.view addSubview:collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:@"ShopCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    collectionView.showsHorizontalScrollIndicator = NO;
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor orangeColor];
    
    
    cell.indexPath = indexPath;
    

    
    return cell;
}



@end
