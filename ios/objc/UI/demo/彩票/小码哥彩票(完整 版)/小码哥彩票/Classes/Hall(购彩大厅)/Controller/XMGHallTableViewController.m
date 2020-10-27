//
//  XMGHallTableViewController.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/10.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGHallTableViewController.h"
#import "UIImage+XMG.h"
#import "XMGCover.h"
#import "XMGPopMenu.h"
#import "UIView+XMG.h"

@interface XMGHallTableViewController ()<XMGPopMenuDelegate>

@end

@implementation XMGHallTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 在iOS7以后导航控制器上得图片默认是渲染的
    // 设置image 呈现方式
//   UIImage *image = [UIImage imageNamed:@"CS50_activity_image"];
//   image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
//    [UIImage imageWithOriginal:<#(NSString *)#>]
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginal:@"CS50_activity_image"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarOnClick)];
    
}
// 当导航条左侧按钮点击就会调用
- (void)leftBarOnClick{
    // 蒙版一般加载窗口上
    // 弹出蒙版,
    [XMGCover show];

    // 创建pop菜单
    XMGPopMenu *popMenu = [XMGPopMenu showInCenter:self.view.center];
    popMenu.delegae = self;
    
}
#pragma mark - XMGPopMenuDelegate
- (void)popMenudDidColseBtn:(XMGPopMenu *)popMenu{
    
//    [UIView animateWithDuration:0 animations:nil completion:^(BOOL finished) {
//        
//    }];
    
    // 封装菜单动画执行完毕的时候调用的代码
    void (^completion)() = ^{
        // 当菜单的动画执行完毕的时候,隐藏蒙版
        [XMGCover hidden];
    };
    
    // block精髓: 当参数传递
    // 关闭菜单
    [popMenu hiddenInCenter:CGPointMake(44, 44) completion:completion];
    
    // 关闭菜单
//    [popMenu hiddenInCenter:CGPointMake(44, 44) completion:^{
//    
//    }];
    
    
    
}
@end
