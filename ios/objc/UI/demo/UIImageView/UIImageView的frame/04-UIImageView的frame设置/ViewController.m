//
//  ViewController.m
//  04-UIImageView的frame设置
//
//  Created by xiaomage on 15/12/26.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    
    
    // 设置frame的方式
    // 方式一
      UIImageView *imageView = [[UIImageView alloc] init];
      imageView.image = [UIImage imageNamed:@"1"];
     
//    imageView.frame = CGRectMake(100, 100, 267, 400);
//    imageView.frame = (CGRect){{100, 100},{267, 400}};
    */
    
    // 方式二
    /*
    UIImageView *imageView = [[UIImageView alloc] init];
    // 创建一个UIImage对象
    UIImage *image = [UIImage imageNamed:@"1"];
    // 设置frame
    imageView.frame = CGRectMake(100, 10, image.size.width, image.size.height);
    // 设置图片
    imageView.image = image;
     */
    
    // 方式三
    /*
    // 创建一个UIImage对象
    UIImage *image = [UIImage imageNamed:@"1"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 10, image.size.width, image.size.height)];
    imageView.image = image;
     */
    
    // 方式四
    
    // 创建一个UIimageview对象
    // 注意: initWithImage 默认就有尺寸--->图片的尺寸
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    
    // 改变位置
//    imageView.center = CGPointMake(200, 150);
    
    imageView.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    
    [self.view addSubview:imageView];
}

@end
