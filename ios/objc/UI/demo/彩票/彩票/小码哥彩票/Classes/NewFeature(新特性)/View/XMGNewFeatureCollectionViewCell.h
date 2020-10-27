//
//  XMGNewFeatureCollectionViewCell.h
//  小码哥彩票
//
//  Created by xiaomage on 16/1/30.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGNewFeatureCollectionViewCell : UICollectionViewCell

/** 背景图片 */
@property (nonatomic, strong) UIImage *image;

- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count;

@end
