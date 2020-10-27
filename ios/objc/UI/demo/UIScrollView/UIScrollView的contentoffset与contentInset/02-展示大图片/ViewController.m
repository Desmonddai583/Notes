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
    // 1.UIImageView
    UIImage *image = [UIImage imageNamed:@"minion"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.scrollView addSubview:imageView];
    
    // 2.设置contentSize
    self.scrollView.contentSize = image.size;
    
    // 3.内容的偏移量
    // 作用1:控制内容滚动的位置
    // 作用2:得知内容滚动的位置
    self.scrollView.contentOffset = CGPointMake(0, -100);
    
    // 4.内边距
    self.scrollView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
}

/**
 *  点击控制器的view会自动调用这个方法
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    self.scrollView.contentOffset = CGPointMake(-100, -100);
}


#pragma mark - 按钮的点击

- (IBAction)top {
    /*
    [UIView animateWithDuration:2.0 animations:^{
//        CGPoint offset = self.scrollView.contentOffset;
//        offset.y = 0;
//        self.scrollView.contentOffset = offset;
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
    }];
     */
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 0) animated:YES];
    
}

- (IBAction)bottom {
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat offsetY = self.scrollView.contentSize.height - self.scrollView.frame.size.height;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.scrollView setContentOffset:offset animated:YES];
}

- (IBAction)left {
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:YES];
}

- (IBAction)right {
    
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat offsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.scrollView setContentOffset:offset animated:YES];
}

- (IBAction)rightTop {
    
}

- (IBAction)leftBottom {
    
}
@end
