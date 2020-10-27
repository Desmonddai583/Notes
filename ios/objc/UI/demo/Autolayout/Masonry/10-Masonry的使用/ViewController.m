//
//  ViewController.m
//  10-Masonry的使用
//
//  Created by xiaomage on 16/1/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"


//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.蓝色的view
    UIView *blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blueView];
    
    // 2.红色的view
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    /*** 添加新的约束 ***/
    // 3.设置蓝色view的约束
    [blueView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left).offset(30);
        make.bottom.equalTo(self.view.bottom).offset(-30);
        make.right.equalTo(redView.left).offset(-30);
        make.width.equalTo(redView.width);
//        make.height.equalTo(50);
    }];
    
    // 4.设置红色view的约束
    [redView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.right).offset(-30);
        make.top.equalTo(blueView.top);
        make.bottom.equalTo(blueView.bottom);
    }];
    
    /*** 更新约束 ****/
   [blueView updateConstraints:^(MASConstraintMaker *make) {
       make.height.equalTo(80);
   }];
    
    // 删除之前所有的约束,添加新的约束
//    [blueView remakeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
    
    // with  /and
}

- (void)center
{
    // 1.红色的view
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    // 2.添加约束
    //    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.width.equalTo(@100);
    //        make.height.equalTo(@100);
    //        make.centerX.equalTo(self.view.mas_centerX);
    //        make.centerY.equalTo(self.view.mas_centerY);
    //    }];
    
    //    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.width.mas_equalTo(100);
    //        make.height.mas_equalTo(100);
    //        make.centerX.mas_equalTo(self.view.mas_centerX);
    //        make.centerY.mas_equalTo(self.view.mas_centerY);
    //    }];
    
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.center.mas_equalTo(self.view);
    }];
}
- (void)edge
{
    // 1.红色的view
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    // 2.添加约束
    //    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.view.mas_top).offset(20);
    //        make.left.equalTo(self.view.mas_left).offset(20);
    //        make.right.equalTo(self.view.mas_right).offset(-20);
    //        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
    //    }];
    //    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.view).offset(20);
    //        make.left.equalTo(self.view).offset(20);
    //        make.right.equalTo(self.view).offset(-20);
    //        make.bottom.equalTo(self.view).offset(-20);
    //    }];
    //    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.offset(20);
    //        make.left.offset(20);
    //        make.right.offset(-20);
    //        make.bottom.offset(-20);
    //    }];
    //    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.offset(20);
    //        make.right.bottom.offset(-20);
    //    }];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(20, 20, 20, 20));
    }];

}

@end
