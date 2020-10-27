//
//  XMGShopView.m
//  03-通过xib自定义商品的View
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//


/**
   xib使用注意事项:
   1> 如果一个view从xib中加载,就不能用[xxx alloc] init] 和 [xxx alloc] initWithFrame:]创建
   2> 如果一个xib经常被使用,应该提供快速构造类方法
   3> 如果一个view从xib中加载:
      用代码添加一些子控件,得在 initWithCoder: 和 awakeFromNib 创建
   4> 如果一个view从xib中加载,会调用initWithCoder: 和 awakeFromNib,不会调用init和initWithFrame:方法
 */
#import "XMGShopView.h"

@interface XMGShopView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** 测试label */
@property (nonatomic, weak) UILabel *label;
/** 毛玻璃 */
@property (nonatomic, weak) UIToolbar *toolBar;
@end

@implementation XMGShopView

/**
 *  如果View从xib中加载,就不会调用init和initWithFrame:方法
 *
 */
/*
- (instancetype)init{
    if (self = [super init]) {
        NSLog(@"%s", __func__);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       NSLog(@"%s", __func__);
    }
    return self;
}
 */

/**
*  如果View从xib中加载,就会调用initWithCoder:方法
*  创建子控件,...
   注意: 如果子控件是从xib中创建,是处于未唤醒状态
*/
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        /*
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor grayColor];
        label.text = @"哈哈哈哈哈哈";
        [self addSubview:label];
        self.label = label;
         */
        NSLog(@"1");
        
    }
    return self;
}

#pragma mark - xib的加载原理
- (UIView *)loadFormNib{
    XMGShopView *shopView = [[XMGShopView alloc] initWithCoder:nil];
    shopView.frame = CGRectMake(0, 0, 80, 100);
    
    UIImageView *iconView = [[UIImageView alloc] initWithCoder:nil];
    iconView.backgroundColor = [UIColor greenColor];
    iconView.frame = CGRectMake(0, 0, 80, 80);
    iconView.tag = 100;
    [shopView addSubview:iconView];
    self.iconView = iconView;
    
    UILabel *label = [[UILabel alloc] initWithCoder:nil];
    label.backgroundColor = [UIColor orangeColor];
    label.tag = 200;
    [shopView addSubview:label];
    self.titleLabel = label;
    
    return shopView;
}

/**
 *  从xib中唤醒
    添加 xib中创建的子控件 的子控件
 */
- (void)awakeFromNib{
    // 往imageView上加毛玻璃
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [self.iconView addSubview:toolBar];
    self.toolBar = toolBar;
    NSLog(@"2");
}


#pragma mark - 快速构造方法
+ (instancetype)shopView{
    return [[[NSBundle mainBundle] loadNibNamed:@"XMGShopView" owner:nil options:nil] firstObject];
}

#pragma mark - 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    /*
    self.label.frame = self.bounds;
     */
    self.toolBar.frame = self.iconView.bounds;
}


#pragma mark - 设置数据
- (void)setIcon:(NSString *)icon{
    self.iconView.image = [UIImage imageNamed:icon];
}

- (void)setName:(NSString *)name{
    self.titleLabel.text = name;
}
@end
