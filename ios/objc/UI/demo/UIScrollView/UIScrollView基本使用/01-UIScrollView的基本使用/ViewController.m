//
//  ViewController.m
//  01-UIScrollView的基本使用
//
//  Created by xiaomage on 16/1/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.红色的view
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    redView.frame = CGRectMake(0, 0, 50, 50);
    [self.scrollView addSubview:redView];
    
    // 默认scrollView设置该属性为YES
//    self.scrollView.clipsToBounds = YES;
    // 2.设置内容尺寸(滚动范围)
    // 可滚动尺寸:contentSize的尺寸 减去 scrollView的尺寸
    // 注意点:contentSize的尺寸小于或者等于scrollView的尺寸也是不可以滚定的
    self.scrollView.contentSize = CGSizeMake(325, 225);
    
    // 3.是否能够滚动
//    self.scrollView.scrollEnabled = NO;
    
    // 4.是否能够跟用户交互(响应用户的点击等操作)
    // 注意点:设置userInteractionEnabled = NO,scrollView以及内部所有的子控件都不能跟用户交互
//    self.scrollView.userInteractionEnabled = NO;
    
    
    /*
    UIButton *btn = nil;
    btn.enabled = NO;
    btn.userInteractionEnabled = NO;
    
    UIControlStateNormal;
    UIControlStateHighlighted;
    // 注意点:只有设置按钮的enabled = NO才能达到这个状态;
    // 设置按钮的userInteractionEnabled = NO 是达不到这个状态
    UIControlStateDisabled;
     */
}



@end
