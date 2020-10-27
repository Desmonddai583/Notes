//
//  ViewController.m
//  09-UIButton内部子控件的调整
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.1 创建按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // 1.2 设置frame
    button.frame = CGRectMake(100, 100, 170, 70);
    
    // 1.3 设置背景颜色
    button.backgroundColor = [UIColor purpleColor];
    
    // 1.4 设置文字
    [button setTitle:@"普通按钮" forState:UIControlStateNormal];
    
    // 1.5 设置内容图片
    [button setImage:[UIImage imageNamed:@"miniplayer_btn_playlist_normal"] forState:UIControlStateNormal];
    
    // 1.6 改变位置
    button.imageView.backgroundColor = [UIColor yellowColor];
    button.titleLabel.backgroundColor = [UIColor blueColor];
    // 注意: 在按钮外面改的尺寸,按钮的内部都会覆盖掉
    /*
    button.titleLabel.frame = CGRectMake(0, 0, 100, 70);
    button.imageView.frame = CGRectMake(100, 0, 70, 70);
     */
    
    [button titleRectForContentRect:CGRectMake(0, 0, 100, 70)];
    [button imageRectForContentRect:CGRectMake(100, 0, 70, 70)];
    
    [self.view addSubview:button];
}

@end
