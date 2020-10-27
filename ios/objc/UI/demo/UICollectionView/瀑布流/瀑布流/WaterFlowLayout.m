//
//  WaterFlowLayout.m
//  瀑布流
//
//  Created by yz on 15/11/25.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "WaterFlowLayout.h"

@interface WaterFlowLayout ()

@property (nonatomic, strong) NSMutableArray *columnsHeight;

@property (nonatomic, strong) NSMutableArray *cellLayouts;

@property (nonatomic, assign) CGFloat maxColumnHeight;

@end

@implementation WaterFlowLayout

static CGFloat const margin = 10;
static CGFloat const cols = 3;


- (NSMutableArray *)cellLayouts
{
    if (_cellLayouts == nil) {
        _cellLayouts = [NSMutableArray array];
    }
    return _cellLayouts;
}

- (NSMutableArray *)columnsHeight
{
    if (_columnsHeight == nil) {
        _columnsHeight = [NSMutableArray array];
        
        for (int i = 0; i < cols; i++) {
            [_columnsHeight addObject:@(margin)];
        }
        
    }
    return _columnsHeight;
}
/*
    计算瀑布流布局思路
    1.确定宽度:
    2.确定高度:
    3.确定列数
    4.x跟列有关
    5.y需要判断，当前哪列最矮，就放哪列
    6.搞个数组记录下每一列的高度,只需要记录一次，懒加载
    7.判断完最矮的列数，添加完之后一定要记得更新最矮列数.
 
    // 存在的问题：
    // 不能滚动，需要计算滚动范围,怎么计算，搞个属性记录下最大列的高度，每次新增一个cell时，判断是否比之前的大，大就记录
    // 滚动范围的方法比计算cell行高的方法先调用
    // 瀑布流的布局都是固定死的，一开始就能确定，可以在prepareLayout方法中布局.
 
 */


- (void)prepareLayout
{
    [super prepareLayout];
    
    // 所有行高清空
    self.columnsHeight = nil;
    
    // 每次布局，应该先把之前的清空
    [self.cellLayouts removeAllObjects];
    
    // 布局所有的cell
    [self setUpAllCellLayout];
}

- (void)setUpAllCellLayout
{
    
    // 获取cell总数
    NSUInteger count = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    
    CGFloat collectionW = self.collectionView.bounds.size.width;
    
    CGFloat cellW = (collectionW - (cols + 1) * margin) / cols;
    CGFloat cellH = 0;
    CGFloat cellX = 0;
    CGFloat cellY = 0;
    
    // 计算所有cell布局
    for (int i = 0; i < count; i++) {
        
        cellH = 100 + arc4random_uniform(100);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // UICollectionViewLayoutAttributes:不能alloc,init创建
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        // 遍历列数高度数组，判断最矮的列数
        // 记录最小的列数
        NSInteger minCol = 0;
        
        // 获取第0列比较
        CGFloat minColumnH = [self.columnsHeight[0] floatValue];
        
        for (int i = 1; i < self.columnsHeight.count; i++) {
            CGFloat curColH = [self.columnsHeight[i] floatValue];
            if (curColH < minColumnH) {
                // 有最矮的
                minColumnH = curColH;
                minCol = i;
            }
        }
        
        cellX = margin + minCol * (margin + cellW);
        cellY = minColumnH + margin;
        
        // 更新最小列行高
        
        // 计算尺寸
        attrs.frame = CGRectMake(cellX, cellY, cellW, cellH);
        
        // 新增cell的行高
        CGFloat newHeight = cellY + cellH;
        self.columnsHeight[minCol] = @(newHeight);
        
        if (newHeight > self.maxColumnHeight) {
            self.maxColumnHeight = newHeight;
        }
        
        
        [self.cellLayouts addObject:attrs];
    }
}


// 返回指定区域内容cell的布局
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.cellLayouts;
}

- (CGSize)collectionViewContentSize
{
    
    return CGSizeMake(self.collectionView.bounds.size.width, self.maxColumnHeight);
}

@end
