//
//  XMGShopView.m
//  03-综合练习
//
//  Created by xiaomage on 15/12/29.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGShopView.h"
#import "XMGShop.h"

@interface XMGShopView ()
/** 图片控件 */
@property (nonatomic, weak) UIImageView *iconView;
/** 标题控件 */
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation XMGShopView

/**
 *  初始化子控件(不要设置frame)
 *
 */
- (instancetype)init{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}


/**
 * 注意: 创建对象用[[xxx alloc]init]方法和[[xxx alloc]initWithFrame]:方法都会调用initWithFrame:
 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithShop:(XMGShop *)shop{
    if (self = [super init]) {
        // 注意:先创建后赋值
        [self setUp];
        self.shop = shop;
    }
    return self;
}

+ (instancetype)shopViewWithShop:(XMGShop *)shop{
    return [[self alloc] initWithShop:shop];
}

/**
 *  初始化
 */
- (void)setUp{
    // 1.创建商品的UIImageView对象
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.backgroundColor = [UIColor blueColor];
    [self addSubview:iconView];
    _iconView = iconView;
    
    // 2.创建商品标题对象
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor yellowColor];
    titleLabel.textAlignment = NSTextAlignmentCenter; // 居中
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
}



/**
 *  布局子控件(可以拿到frame)
 */
- (void)layoutSubviews{
    // 0.一定要调用super
    [super layoutSubviews];
    
    // 1.获取当前控件的尺寸
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    // 2.设置子控件的frame
     self.iconView.frame = CGRectMake(0, 0, width, width);
     self.titleLabel.frame = CGRectMake(0, width, width, height - width);
}

/**
 *  set方法:只要外边传数据就会调用
 *  作用:设置数据
 */
- (void)setShop:(XMGShop *)shop{
    _shop = shop;
    
    // 设置数据
    self.iconView.image = [UIImage imageNamed:shop.icon];
    self.titleLabel.text = shop.name;
}


@end
