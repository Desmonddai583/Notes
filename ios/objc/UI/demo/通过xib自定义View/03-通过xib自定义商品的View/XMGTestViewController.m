//
//  XMGTestViewController.m
//  03-通过xib自定义商品的View
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGTestViewController.h"
#import "XMGShopView.h"

@interface XMGTestViewController ()

@end

@implementation XMGTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载xib
    XMGShopView *shopView = [[[NSBundle mainBundle] loadNibNamed:@"XMGShopView" owner:nil options:nil] firstObject];
    //    XMGShopView *shopView = [[XMGShopView alloc] initWithFrame: CGRectMake(100, 100, 80, 100)];
    shopView.frame = CGRectMake(100, 100, 80, 100);
    
    // 给子控件设置属性
    /*
     UIImageView *imageView = [shopView viewWithTag:100];
     UILabel *titleLabel = [shopView viewWithTag:200];
     
     imageView.image = [UIImage imageNamed:@"danjianbao"];
     titleLabel.text = @"单肩包";
     */
    [shopView setName:@"单肩包"];
    [shopView setIcon:@"danjianbao"];
    
    [self.view addSubview:shopView];
}

@end
