//
//  XMGStatusCell.m
//  12-自定义不等高的cell-frame01-
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGStatusCell.h"
#import "XMGStatus.h"

#define XMGTextFont [UIFont systemFontOfSize:14]
#define XMGNameFont [UIFont systemFontOfSize:14]
@interface XMGStatusCell ()

/** 图像 */
@property (nonatomic, weak) UIImageView *iconImageView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** vip */
@property (nonatomic, weak) UIImageView *vipImageView;
/** 正文 */
@property (nonatomic, weak) UILabel *text_Label;
/** 配图 */
@property (nonatomic, weak) UIImageView *pictureImageView;
@end

@implementation XMGStatusCell

// 添加子控件的原则:把所有有可能显示的子控件都先添加进去
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /** 图像 */
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        /** 配图 */
        UIImageView *pictureImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:pictureImageView];
        self.pictureImageView = pictureImageView;
        
        /** vip */
        UIImageView *vipImageView = [[UIImageView alloc] init];
        vipImageView.contentMode = UIViewContentModeCenter;
        vipImageView.image = [UIImage imageNamed:@"vip"];
        [self.contentView addSubview:vipImageView];
        self.vipImageView = vipImageView;
        
        /** 昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = XMGNameFont;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        /** 正文 */
        UILabel *text_Label = [[UILabel alloc] init];
        text_Label.font = XMGTextFont;
        text_Label.numberOfLines = 0;
        [self.contentView addSubview:text_Label];
        self.text_Label = text_Label;
    }
    return self;
}

/**
 *  设置所有的子控件的frame
 */
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.iconImageView.frame = self.status.iconFrame;
//    self.nameLabel.frame = self.status.nameFrame;
//    self.vipImageView.frame = self.status.vipFrame;
//    self.text_Label.frame = self.status.textFrame;
//    self.pictureImageView.frame = self.status.pictureFrame;
//}

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
    
    self.iconImageView.frame = self.status.iconFrame;
    self.nameLabel.frame = self.status.nameFrame;
    self.vipImageView.frame = self.status.vipFrame;
    self.text_Label.frame = self.status.textFrame;
    self.pictureImageView.frame = self.status.pictureFrame;
}

@end
