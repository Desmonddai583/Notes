//
//  ViewController.m
//  02-UIScrollView底层实现
//
//  Created by xiaomage on 16/3/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 模仿系统控件 => 怎么去使用 => 滚动scrollView,其实本质滚动内容 => 改bounds => 验证
    
    // => 手指往上拖动,bounds y++ ,内容才会往上走
    
    UIView *scrollView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    // 添加Pan手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [scrollView addGestureRecognizer:pan];
    
    UISwitch *switchView = [[UISwitch alloc] init];
    [scrollView addSubview:switchView];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    // 获取手指的偏移量
    CGPoint transP = [pan translationInView:pan.view];
    
    // 修改bounds
    CGRect bounds = _scrollView.bounds;
    bounds.origin.y -= transP.y;
    _scrollView.bounds = bounds;
    
    // 复位
    [pan setTranslation:CGPointZero inView:pan.view];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%@",NSStringFromCGRect(scrollView.bounds));
    
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
