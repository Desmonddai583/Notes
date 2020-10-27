//
//  XMGWineCell.m
//  04-数据刷新-
//
//  Created by xiaomage on 16/1/11.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGWineCell.h"
#import "XMGWine.h"

@interface XMGWineCell ()

/** 打钩控件 */
@property (nonatomic, weak) UIImageView *checkedImageView;
@end
@implementation XMGWineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 添加打钩控件
        UIImageView *checkedImageView = [[UIImageView alloc] init];
        checkedImageView.hidden = YES;
        checkedImageView.image = [UIImage imageNamed:@"check"];
        [self.contentView addSubview:checkedImageView];
        self.checkedImageView = checkedImageView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置打钩的位置和尺寸
    CGFloat WH = 24;
    CGFloat X = self.contentView.frame.size.width - WH - 10;
    CGFloat Y = (self.contentView.frame.size.height - WH) * 0.5;
    self.checkedImageView.frame = CGRectMake(X, Y, WH, WH);
    
    // 调整textLabel的宽度
    CGRect frame = self.textLabel.frame;
    frame.size.width = self.contentView.frame.size.width - WH - 20 - self.textLabel.frame.origin.x;
    self.textLabel.frame = frame;
}

- (void)setWine:(XMGWine *)wine
{
    _wine = wine;
    self.textLabel.text = wine.name;
    self.imageView.image = [UIImage imageNamed:wine.image];
    self.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",wine.money];
    
    // 根据模型的checked属性确定打钩控件显示还是隐藏
    if (wine.isCheched) {
        self.checkedImageView.hidden = NO;
    } else {
        self.checkedImageView.hidden = YES;
    }
}
@end
