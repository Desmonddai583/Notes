//
//  FlowLayout.m
//  01-UICollectionView基本使用
//
//  Created by yz on 15/11/24.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "FlowLayout.h"

@implementation FlowLayout

/*
    1.靠近中心点的时候，cell不断放大，离开中心点,cell不断减小
    2.计算cell距离中心点的位置,获取当前显示cell的布局
    3.默认让第一个显示在中间
    4.定位，滚动完成，让距离中心点最近的cell显示在中心点的位置
    5.判断谁离中心点最近，判断需要用绝对值
    6.记录最小间距，就是最终需要移动的差值，记录不需要绝对值
    7.bug:算出的偏移量-0,修改一下
 */



// UICollectionViewLayoutAttributes: 描述一个cell的布局
// 每个cell对应一个UICollectionViewLayoutAttributes

// 返回在rect区域内所有cell对应的布局

// 方法：返回指定区域下所有cell的布局
// 调用：超出指定区域就会调用
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    // 获取当前滚动区域
    CGFloat offsetX = self.collectionView.contentOffset.x;
    // collection宽度
    CGFloat collectionW = self.collectionView.bounds.size.width;
    
    // 获取当前显示区域
    CGRect visableRect = CGRectMake(offsetX, 0, collectionW, self.collectionView.bounds.size.height);
    
    // 获取当前显示区域的所有cell
    NSArray *visableAtt = [super layoutAttributesForElementsInRect:visableRect];
    
    // 遍历显示cell布局，判断与中心点的距离
    for (UICollectionViewLayoutAttributes *attrs in visableAtt) {
        
        CGFloat delta = fabs((attrs.center.x - offsetX) - collectionW * 0.5) ;
        
        CGFloat scale = 1 - delta / collectionW * 0.5;
        
        attrs.transform = CGAffineTransformMakeScale(scale, scale);

    }
    
    return visableAtt;
}

// Invalidate:刷新
// 是否允许刷新布局，当bounds改变的时候
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}



// 调用时刻：拖动完成时候
// 方法：拖动完成时候的滚动区域
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    
    // collection宽度
    CGFloat collectionW = self.collectionView.bounds.size.width;
    
    CGFloat offsetX = proposedContentOffset.x;
    
    // 获取显示的cell布局
    // 获取当前显示区域
    CGRect visableRect = CGRectMake(offsetX, 0, collectionW, self.collectionView.bounds.size.height);
    
    // 获取当前显示区域的所有cell
    NSArray *visableAtt = [super layoutAttributesForElementsInRect:visableRect];
    
    // 记录最小中心点位置
    CGFloat minDelta = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attrs in visableAtt) {
        
        // 计算离中心点的距离
        CGFloat delta = fabs((attrs.center.x - offsetX) - collectionW * 0.5) ;
        
        // 获取上一个
        if (delta < fabs(minDelta)) { // 比较不需要关心负数
            
            // 有比较小间距的cell
            // 赋值需要
            minDelta = (attrs.center.x - offsetX) - collectionW * 0.5;

        }
    }
    
    proposedContentOffset.x += minDelta;
    // -0，就不会移动
    // 恢复为0

    if (proposedContentOffset.x <= 0) {
        proposedContentOffset.x = 0;
    }
    
    return proposedContentOffset;
    
    
}

// 准备布局
// 什么时候调用:开始布局的时候调用
// 作用: 初始化布局操作
// 计算每个cell的布局，前提：cell尺寸一开始固定
//- (void)prepareLayout{
//
//    NSLog(@"%s",__func__);
//    // 内边距
//
//}

// 返回对应角标cell的布局
// 不会自动调用
//- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"%s",__func__);
//
//    return [super layoutAttributesForItemAtIndexPath:indexPath];
//}



@end
