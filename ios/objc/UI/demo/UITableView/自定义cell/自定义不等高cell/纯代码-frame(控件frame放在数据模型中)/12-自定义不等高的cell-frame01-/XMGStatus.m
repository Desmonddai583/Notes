//
//  XMGStatus.m
//  12-自定义不等高的cell-frame01-
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGStatus.h"

@implementation XMGStatus

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        
        CGFloat space = 10;
        /** 图像 */
        CGFloat iconX = space;
        CGFloat iconY = space;
        CGFloat iconWH = 30;
        self.iconFrame = CGRectMake(iconX, iconY, iconWH, iconWH);
        
        /** 昵称 */
        CGFloat nameX = CGRectGetMaxX(self.iconFrame) + space;
        CGFloat nameY = iconY;
        NSDictionary *nameAtt = @{NSFontAttributeName : [UIFont systemFontOfSize:17]};
        // 计算昵称文字的尺寸
        CGSize nameSize = [self.name sizeWithAttributes:nameAtt];
        CGFloat nameW = nameSize.width;
        CGFloat nameH = nameSize.height;
        self.nameFrame = CGRectMake(nameX, nameY, nameW, nameH);
        
        /** vip */
        if (self.isVip) {
            CGFloat vipX = CGRectGetMaxX(self.nameFrame) + space;
            CGFloat vipW = 14;
            CGFloat vipH = nameH;
            CGFloat vipY = nameY;
            self.vipFrame = CGRectMake(vipX, vipY, vipW, vipH);
        }
        
        /** 正文 */
        CGFloat textX = iconX;
        CGFloat textY = CGRectGetMaxY(self.iconFrame) + space;
        CGFloat textW = [UIScreen mainScreen].bounds.size.width - 2 * space;
        NSDictionary *textAtt = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        // 最大宽度是textW,高度不限制
        CGSize textSize = CGSizeMake(textW, MAXFLOAT);
        CGFloat textH = [self.text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textAtt context:nil].size.height;
        self.textFrame = CGRectMake(textX, textY, textW, textH);
        
        /** 配图 */
        if (self.picture) { // 有配图
            CGFloat pictureWH = 100;
            CGFloat pictureX = iconX;
            CGFloat pictureY = CGRectGetMaxY(self.textFrame) + space;
            self.pictureFrame = CGRectMake(pictureX, pictureY, pictureWH, pictureWH);
            _cellHeight = CGRectGetMaxY(self.pictureFrame) + space;
        } else {
            _cellHeight = CGRectGetMaxY(self.textFrame) + space;
        }

    }
    return _cellHeight;
}

@end
