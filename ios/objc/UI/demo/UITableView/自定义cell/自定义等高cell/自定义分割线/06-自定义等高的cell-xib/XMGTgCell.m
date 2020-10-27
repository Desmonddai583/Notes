//
//  XMGTgCell.m
//  06-自定义等高的cell-xib
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTgCell.h"
#import "XMGTg.h"

@interface XMGTgCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;

@end
@implementation XMGTgCell

- (void)setTg:(XMGTg *)tg
{
    _tg  = tg;
    self.iconImageView.image = [UIImage imageNamed:tg.icon];
    self.titleLabel.text = tg.title;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",tg.price];
    self.buyCountLabel.text = [NSString stringWithFormat:@"%@人已购买",tg.buyCount];
}

@end
