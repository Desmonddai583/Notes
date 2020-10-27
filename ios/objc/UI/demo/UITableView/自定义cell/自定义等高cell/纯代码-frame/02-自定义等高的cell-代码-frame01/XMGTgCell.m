//
//  XMGTgCell.m
//  02-自定义等高的cell-代码-frame01
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTgCell.h"
#import "XMGTg.h"

@interface XMGTgCell ()

/** 图标 */
@property (nonatomic, weak) UIImageView *iconImageView;

/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;

/** 价格 */
@property (nonatomic, weak) UILabel *priceLabel;

/** 购买数 */
@property (nonatomic, weak) UILabel *buyCountLabel;
@end

@implementation XMGTgCell

// 在这个方法中添加所有的子控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /** 图标 */
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        /** 标题 */
        UILabel *titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        /** 价格 */
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = [UIColor orangeColor];
        priceLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:priceLabel];
        self.priceLabel = priceLabel;
        
        /** 购买数 */
        UILabel *buyCountLabel = [[UILabel alloc] init];
        buyCountLabel.textAlignment = NSTextAlignmentRight;
        buyCountLabel.textColor = [UIColor lightGrayColor];
        buyCountLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:buyCountLabel];
        self.buyCountLabel = buyCountLabel;
    }
    return self;
}

// 设置所有的子控件的frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat space = 10;
//    CGFloat contentViewW = self.contentView.frame.size.width;
     CGFloat contentViewW = CGRectGetWidth(self.contentView.frame);
//    CGFloat contentViewH = self.contentView.frame.size.height;
    CGFloat contentViewH = CGRectGetHeight(self.contentView.frame);
    /** 图标 */
    CGFloat iconX = space;
    CGFloat iconY = space;
    CGFloat iconW = 80;
    CGFloat iconH = contentViewH - 2 * space;
    self.iconImageView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    /** 标题 */
//    CGFloat titleX = iconX + iconW + space;
    CGFloat titleX = CGRectGetMaxX(self.iconImageView.frame) + space;
    CGFloat titleY = iconY;
    CGFloat titleW = contentViewW - titleX - space;
    CGFloat titleH = 20;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);

    /** 价格 */
    CGFloat priceW = 100;
    CGFloat priceH = 15;
    CGFloat priceX = titleX;
//    CGFloat priceY = iconY + iconH - priceH;
    CGFloat priceY = CGRectGetMaxY(self.iconImageView.frame) - priceH;
    self.priceLabel.frame = CGRectMake(priceX, priceY, priceW, priceH);

    /** 购买数 */
    CGFloat buyW = 150;
    CGFloat buyH = 14;
    CGFloat buyX = contentViewW - buyW - space;
//    CGFloat buyY = iconY + iconH - buyH;
    CGFloat buyY = CGRectGetMaxY(self.iconImageView.frame) - buyH;
    self.buyCountLabel.frame = CGRectMake(buyX, buyY, buyW, buyH);
}

/**
 *  设置子控件的数据
 */
- (void)setTg:(XMGTg *)tg
{
    _tg = tg;
    self.iconImageView.image = [UIImage imageNamed:tg.icon];
    self.titleLabel.text = tg.title;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",tg.price];
    self.buyCountLabel.text = [NSString stringWithFormat:@"%@人已购买",tg.buyCount];
}
@end
