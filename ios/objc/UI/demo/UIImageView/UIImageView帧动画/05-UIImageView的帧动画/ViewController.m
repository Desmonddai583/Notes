//
//  ViewController.m
//  05-UIImageView的帧动画
//
//  Created by xiaomage on 15/12/26.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
/**
 *  属性
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.imageView.image = [UIImage imageNamed:@"a1"];
    
}

#pragma mark - 开始动画
- (IBAction)startAnimation {
    // 1.1 加载所有的图片
    NSMutableArray<UIImage *> *imageArr = [NSMutableArray array];
    for (int i=0; i<20; i++) {
        // 获取图片的名称
        NSString *imageName = [NSString stringWithFormat:@"%d", i+1];
        // 创建UIImage对象
        UIImage *image = [UIImage imageNamed:imageName];
        // 加入数组
        [imageArr addObject:image];
    }
    // 设置动画图片
    self.imageView.animationImages = imageArr;
    
    // 设置动画的播放次数
    self.imageView.animationRepeatCount = 0;
    
    // 设置播放时长
    // 1秒30帧, 一张图片的时间 = 1/30 = 0.03333 20 * 0.0333
    self.imageView.animationDuration = 1.0;
    
    // 开始动画
    [self.imageView startAnimating];
}

#pragma mark - 结束动画
- (IBAction)overAnimation {
    [self.imageView stopAnimating];
}
@end
