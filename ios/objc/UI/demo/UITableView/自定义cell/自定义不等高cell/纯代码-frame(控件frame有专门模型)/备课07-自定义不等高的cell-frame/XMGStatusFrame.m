//
//  XMGStatusFrame.m
//  备课07-自定义不等高的cell-frame
//
//  Created by FTD_ZHC on 15/9/23.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGStatusFrame.h"
#import "XMGStatus.h"

@implementation XMGStatusFrame

- (void)setStatus:(XMGStatus *)status
{
    _status = status;
    // 定义一个间距
    CGFloat space = 10;
    /** 头像 */
    CGFloat iconX = space;
    CGFloat iconY = space;
    CGFloat iconWH = 30;
    CGRect iconImageViewFrame = CGRectMake(iconX, iconY, iconWH, iconWH);
    self.iconFrame = iconImageViewFrame;

    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(iconImageViewFrame) + space;
    CGFloat nameY = iconY;
    // 计算昵称文字的尺寸
    CGSize nameSize = [self.status.name sizeWithAttributes:@{
                                                             NSFontAttributeName : XMGNameFont
                                                             }
                       ];
    CGRect nameLabelFrame = (CGRect){{nameX,nameY},nameSize};
    self.nameFrame = nameLabelFrame;

    /** vip */
    if (status.isVip) {
        CGFloat vipWH = 14;
        CGFloat vipX = CGRectGetMaxX(nameLabelFrame) + space;
        CGFloat vipY = nameY + (nameSize.height - vipWH) * 0.5;
        CGRect vipImageViewFrame = CGRectMake(vipX, vipY, vipWH, vipWH);
        self.vipFrame = vipImageViewFrame;
    }

    /** 内容(正文) */
    CGFloat textX = iconX;
    CGFloat textY = CGRectGetMaxY(iconImageViewFrame) + space;
    CGFloat textW = [UIScreen mainScreen].bounds.size.width - 2 * space;
    // 内容限制的最大尺寸(最大高度为textW,高度不限制)
    CGSize textMaxSize = CGSizeMake(textW,MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [status.text boundingRectWithSize:textMaxSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName : XMGTextFont}
                                                   context:nil].size.height;
    CGRect text_labelFrame = CGRectMake(textX, textY, textW, textH);
    self.textFrame = text_labelFrame;

    /** 配图 */
    if (status .picture) {
        CGFloat pictureX = iconX;
        CGFloat pictureY = CGRectGetMaxY(text_labelFrame) + space;
        CGFloat pictureWH = 100;
        CGRect pictureImageViewFrame = CGRectMake(pictureX, pictureY, pictureWH, pictureWH);
        self.pictureFrame = pictureImageViewFrame;
        _cellHeight = CGRectGetMaxY(pictureImageViewFrame) + space;
    } else {
        _cellHeight= CGRectGetMaxY(text_labelFrame) + space;
    }
}

@end
