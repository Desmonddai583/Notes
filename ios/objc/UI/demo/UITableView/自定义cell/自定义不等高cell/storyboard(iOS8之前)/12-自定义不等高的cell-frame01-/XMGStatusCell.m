//
//  XMGStatusCell.m
//  12-自定义不等高的cell-frame01-
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGStatusCell.h"
#import "XMGStatus.h"

@interface XMGStatusCell ()

/** 图像 */
@property (nonatomic, weak)IBOutlet UIImageView *iconImageView;
/** 昵称 */
@property (nonatomic, weak)IBOutlet UILabel *nameLabel;
/** vip */
@property (nonatomic, weak)IBOutlet UIImageView *vipImageView;
/** 正文 */
@property (nonatomic, weak)IBOutlet UILabel *text_Label;
/** 配图 */
@property (nonatomic, weak)IBOutlet UIImageView *pictureImageView;


@end

@implementation XMGStatusCell

- (void)awakeFromNib
{
    // 手动设置文字的最大宽度(让label能够计算出自己最真实的尺寸)
    self.text_Label.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 20;
}

/**
 *  设置子控件的数据
 */
- (void)setStatus:(XMGStatus *)status
{
    _status = status;
    self.iconImageView.image = [UIImage imageNamed:status.icon];
    self.nameLabel.text = status.name;
    
    if (status.isVip) {
        self.nameLabel.textColor = [UIColor orangeColor];
        self.vipImageView.hidden = NO;
    } else {
        self.vipImageView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    self.text_Label.text = status.text;
    
    if (status.picture) { // 有配图
        self.pictureImageView.hidden = NO;
        self.pictureImageView.image = [UIImage imageNamed:status.picture];
    } else { // 无配图
        self.pictureImageView.hidden = YES;
    }
}

- (CGFloat)cellHeight
{
    // 强制刷新(label根据约束自动计算它的宽度和高度)
    [self layoutIfNeeded];
    
    CGFloat cellHeight = 0;
    if (self.status.picture) { // 有配图
        cellHeight = CGRectGetMaxY(self.pictureImageView.frame) + 10;
    } else { // 无配图
        cellHeight = CGRectGetMaxY(self.text_Label.frame) + 10;
    }
    return cellHeight;
}
@end
