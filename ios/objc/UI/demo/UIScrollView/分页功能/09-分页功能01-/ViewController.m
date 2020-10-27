//
//  ViewController.m
//  09-分页功能01-
//
//  Created by xiaomage on 16/1/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加图片
    CGFloat scrollViewW = self.scrollView.frame.size.width;
    CGFloat scrollViewH = self.scrollView.frame.size.height;
    int count = 5;
    for (int i = 0; i < count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name = [NSString stringWithFormat:@"img_0%d",i + 1];
        imageView.image = [UIImage imageNamed:name];
        imageView.frame = CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH);
        [self.scrollView addSubview:imageView];
    }
    
    // 2.设置contentSize
    // 这个0表示竖直方向不可以滚动
    self.scrollView.contentSize = CGSizeMake(count * scrollViewW, 0);
    
    // 3.开启分页功能
    // 标准:以scrollView的尺寸为一页
    self.scrollView.pagingEnabled = YES;
    
    // 4.设置总页数
    self.pageControl.numberOfPages = count;
    
    // 5.单页的时候是否隐藏pageControl
    self.pageControl.hidesForSinglePage = YES;
    
    // 6.设置pageControl的图片
    [self.pageControl setValue:[UIImage imageNamed:@"current"] forKeyPath:@"_currentPageImage"];
    [self.pageControl setValue:[UIImage imageNamed:@"other"]  forKeyPath: @"_pageImage"];
    
   // 7.开启定时器
    [self startTimer];

}

// 线程
// 主线程:程序一启动,系统会默认创建一条线程.
// 主线程作用:显示刷新UI界面,处理与用用户的交互事件
// 多线程的原理: 1s --->  1万个0.0001s

#pragma mark - 定时器相关的代码
- (void)startTimer
{
    // 返回一个自动执行的定时器对象
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage:) userInfo:@"123" repeats:YES];
    // NSDefaultRunLoopMode(默认): 同一时间只能执行一个任务
    // NSRunLoopCommonModes(公用): 可以分配一定的时间执行其他任务
    // 作用:修改timer在runLoop中的模式为NSRunLoopCommonModes
    // 目的:不管主线程在做什么操作,都会分配一定的时间处理定时器
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [self.timer invalidate];
}

/**
 *  滚动到下一页
 */
- (void)nextPage:(NSTimer *)timer
{
    // 1.计算下一页的页码
    NSInteger page = self.pageControl.currentPage + 1;
    
    // 2.超过了最后一页
    if ( page == 5) {
        page = 0;
    }
    
    // 3.滚动到下一页
    [self.scrollView setContentOffset:CGPointMake(page * self.scrollView.frame.size.width, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.计算页码
    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);

    // 2.设置页码
    self.pageControl.currentPage = page;
}

/**
 *  用户即将开始拖拽scrollView时,停止定时器
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

/**
 *  用户已经停止拖拽scrollView时,开启定时器
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
@end
