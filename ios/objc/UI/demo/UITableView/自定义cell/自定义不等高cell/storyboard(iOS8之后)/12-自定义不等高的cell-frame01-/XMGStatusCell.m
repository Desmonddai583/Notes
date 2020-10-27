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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pitureHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureBottom;

@end

@implementation XMGStatusCell


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
        self.pitureHeight.constant = 100;
        self.pictureBottom.constant = 10;
    } else { // 无配图
        self.pictureImageView.hidden = YES;
        self.pitureHeight.constant = 0;
        self.pictureBottom.constant = 0;
    }
}

@end
