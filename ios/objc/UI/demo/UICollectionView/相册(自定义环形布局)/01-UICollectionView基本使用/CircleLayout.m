//
//  CircleLayout.m
//  01-UICollectionView基本使用
//
//  Created by yz on 15/11/24.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "CircleLayout.h"

@interface CircleLayout()



@end


@implementation CircleLayout
/*
    确定大圆(圆心，半径)，然后cell平分大圆
 
 */


// 设置每个cell的布局



// 返回一定区域内cell的尺寸
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{

    
    NSMutableArray *attrs = [NSMutableArray array];
    
    // 计算cell的布局
    
    // 获取大圆的中心点
    CGPoint circleCenter = CGPointMake(self.collectionView.bounds.size.width * 0.5, self.collectionView.bounds.size.height * 0.5);
    
    CGFloat radius = 150;
    
    // 获取cell总数
    NSInteger count = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < count; i++) {
        // 创建布局对象
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        attr.size = CGSizeMake(100, 100);
        
        // 计算占用的角度
        CGFloat angle = 2 * M_PI / count * i;
        
        CGFloat centerX = circleCenter.x + radius * sin(angle);
        CGFloat centerY = circleCenter.y - radius * cos(angle);
        
        attr.center = CGPointMake(centerX, centerY);
        
        [attrs addObject:attr];
    }
    
    return attrs;
}
@end
