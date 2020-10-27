//
//  ViewController.m
//  05-图片擦除(了解)
//
//  Created by xiaomage on 16/1/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self.imageV addGestureRecognizer:pan];
    
}

- (void)pan:(UIGestureRecognizer *)pan {
    
    //获取当前手指的点
    CGPoint curP =  [pan locationInView:self.imageV];
    
    //确定擦除区域
    CGFloat rectWH = 30;
    CGFloat x = curP.x - rectWH * 0.5;
    CGFloat y = curP.y - rectWH * 0.5;
    CGRect rect = CGRectMake(x, y, rectWH, rectWH);
    
    //生成一张带有透明擦除区域的图片
    
    //1.开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.imageV.bounds.size, NO, 0);
    
    //2.把UIImageV内容渲染到当前的上下文当中
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.imageV.layer renderInContext:ctx];
    
    //3.擦除上下文当中的指定的区域
    CGContextClearRect(ctx, rect);
    
    //4.从上下文当中取出图片
    UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
    
    //替换之前ImageView的图片
    self.imageV.image = newImage;

 
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
