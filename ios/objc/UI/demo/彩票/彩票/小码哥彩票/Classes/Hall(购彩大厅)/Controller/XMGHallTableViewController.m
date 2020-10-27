//
//  XMGHallTableViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGHallTableViewController.h"
#import "UIImage+XMG.h"
#import "XMGCover.h"
#import "XMGPopMenu.h"
//#import "UIView+Frame.h"

@interface XMGHallTableViewController ()<XMGPopMenuDelegate>

@end

@implementation XMGHallTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 在iOS7 之后导航条上图片,默认被渲染
    
    // 1.设置导航条左侧按钮
//    UIImage *image =  [UIImage imageNamed:@"CS50_activity_image"];
//   image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage imageWithRenderOriginalName:<#(NSString *)#>
    
//    [UIImage imageWithRenderOriginalName:<#(NSString *)#>]
    
//    [UIImage imageWithRenderOriginalName:]
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithRenderOriginalName:@"CS50_activity_image"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonOnClick)];
    
}

- (void)leftButtonOnClick{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);

    // 有谁添加有谁移除
    
//    UIAlertView *alert = nil;
//    [alert show];
//    
    // 1.弹出蒙版.占据整个屏幕,不允许与用户交互
    [XMGCover show];
    
    // 2.添加popMenu
//     1.蒙版上
    // 2.窗口上
   XMGPopMenu *popMenu = [XMGPopMenu showInCenter:self.view.center];
    popMenu.delegate = self;
    
//    UIButton *button = nil;

//   CGFloat w = popMenu.width;
//    NSLog(@"%f",w);
    
//    popMenu.width = 10;
//    popMenu.height = 20;
//    popMenu.x = 100;
//    popMenu.y = 50;
    
//     NSLog(@"之后%f",popMenu.width);
//    NSLog(@"%@",NSStringFromCGRect(popMenu.frame));
    
//    CGRect frame = popMenu.frame;
//    frame.size.width = 10;
//    popMenu.frame = frame;
    
//    self.view.frame 
    
}
#pragma mark - XMGPopMenuDelegate
- (void)popMenuDidCloseBtn:(XMGPopMenu *)popMenu{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    [UIView animateWithDuration:0 animations:^{
        
    }];
    
    
    void(^completion)() =^(){
        // 2.移除蒙版
        // 当动画执行完毕的时候移除蒙版
        [XMGCover hide];
    };
    
    // 隐藏popMenu
    [popMenu hideInCenter:CGPointMake(44, 44) completion:completion];
    

    // block 可以保存一段代码,在需要的时候调用
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
}
@end
