//
//  XMGNewFeatureCollectionViewCell.h
//  小码哥彩票
//
//  Created by simplyou on 15/11/13.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGNewFeatureCollectionViewCell : UICollectionViewCell
/**
 *  背景图片
 */
@property (nonatomic, strong) UIImage *image;

- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count;
@end
