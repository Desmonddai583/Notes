//
//  XMGShopView.m
//  03-综合练习
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGShopView.h"
#import "XMGShop.h"

@interface XMGShopView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@end

@implementation XMGShopView

+ (instancetype)shopView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

//- (void)awakeFromNib

- (void)setShop:(XMGShop *)shop{
    _shop = shop;
    
    // 设置子控件的数据
    self.iconView.image = [UIImage imageNamed:shop.icon];
    self.titlelabel.text = shop.name;
}
@end
