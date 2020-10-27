//
//  ViewController.m
//  02-展示大图片
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
    
//    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    indicatorView.center = CGPointMake(100, -40);
//    [indicatorView startAnimating];
//    [self.scrollView addSubview:indicatorView];
    
    // 1.UIImageView
    UIImage *image = [UIImage imageNamed:@"minion"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.scrollView addSubview:imageView];
    
    NSLog(@"11-->%@",self.scrollView.subviews);
    
    // 2.设置contentSize
    self.scrollView.contentSize = image.size;
    
    // 3.是否有弹簧效果
//    self.scrollView.bounces = NO;
    
    // 4.不管有没有设置contentSize,总是有弹簧效果(下拉刷新)
//    self.scrollView.alwaysBounceHorizontal = YES;
//    self.scrollView.alwaysBounceVertical = YES;
    
    // 5.是否显示滚动条
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.showsVerticalScrollIndicator = NO;
    
    NSLog(@"22--->%@",self.scrollView.subviews);
    // 注意点:千万不要通过索引去subviews数组访问scrollView子控件
//    [self.scrollView.subviews.firstObject removeFromSuperview];
    
}


@end
