//
//  ViewController.m
//  05-UIScrollView的代理(delegate)
//
//  Created by xiaomage on 16/1/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.frame = CGRectMake(0, 20, 300, 200);
    [self.view addSubview:scrollView];
    
    // 注意点:通过代码创建scrollView,一开始subviews这个数组为nil
//    NSLog(@"%@",scrollView.subviews);
    
    // 1.创建UIImageView
    UIImage *image = [UIImage imageNamed:@"minion"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [scrollView addSubview:imageView];
    
    // 2.设置contenSize
    scrollView.contentSize = image.size;
    
    // 3.设置代理
    scrollView.delegate = self;
}

#pragma mark - UIScrollViewDelegate 代理方法
/**
 *  当scrollView正在滚动的时候就会自动调用这个方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewDidScroll--");
}

/**
 *  用户即将开始拖拽scrollView时就会调用这个方法
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging-");
}

/**
 *  用户即将停止拖拽scrollView时就会调用这个方法
 */
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    NSLog(@"scrollViewWillEndDragging");
}

/**
 *  用户已经停止拖拽scrollView时就会调用这个方法
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO) {
        NSLog(@"用户已经停止拖拽scrollView,停止滚动");
    } else {
        NSLog(@"用户已经停止拖拽scrollView,但是scrollView由于惯性会继续滚动,减速");
    }
}

/**
 * scrollView减速完毕会调用,停止滚动
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   NSLog(@"scrollView减速完毕会调用,停止滚动");
}
@end
