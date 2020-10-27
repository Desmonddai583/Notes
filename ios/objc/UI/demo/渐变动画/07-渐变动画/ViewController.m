//
//  ViewController.m
//  07-渐变动画
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *animationView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  平移
 */
- (IBAction)translate {
    // 渐变动画
    // 方式一
    /*
    // 1. 开始动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    
    // 2.动画代码
    CGRect frame = self.animationView.frame;
    frame.origin.y -= 50;
    self.animationView.frame = frame;
    
    // 3.提交动画
    [UIView commitAnimations];
     */
    
    // 方式二:
    /*
    [UIView animateWithDuration:2.0 animations:^{
        // 1.动画代码
        CGRect frame = self.animationView.frame;
        frame.origin.y -= 50;
        self.animationView.frame = frame;
    }];
     */
    
    /*
    [UIView animateWithDuration:1.0 animations:^{
        // 执行动画
        CGRect frame = self.animationView.frame;
        frame.origin.y -= 50;
        self.animationView.frame = frame;
    } completion:^(BOOL finished) {
       // 动画完成做什么事情
        self.animationView.backgroundColor = [UIColor blackColor];
    }];
     */
    /*
     UIViewAnimationOptionCurveEaseInOut  动画开始/结束比较缓慢,中间相对较快
     UIViewAnimationOptionCurveEaseIn     动画开始比较缓慢
     UIViewAnimationOptionCurveEaseOut    动画结束比较缓慢
     UIViewAnimationOptionCurveLinear     线性---> 匀速
     */
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGRect frame = self.animationView.frame;
        frame.origin.y += 50;
        self.animationView.frame = frame;
        
    } completion:^(BOOL finished) {
        self.animationView.backgroundColor = [UIColor greenColor];
    }];
}

/**
 *  缩放
 */
- (IBAction)scale {
    
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect frame = self.animationView.frame;
        frame.size = CGSizeMake(10, 15);
        self.animationView.frame = frame;
        
    } completion:^(BOOL finished) {
        NSLog(@"动画完成");
    }];
}

/**
 *  透明度动画
 */
- (IBAction)alpha {
    [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.animationView.alpha -= 0.9;
    } completion:^(BOOL finished) {
       [UIView animateWithDuration:2.0 animations:^{
           self.animationView.alpha += 0.9;
       }];
    }];
}
@end
