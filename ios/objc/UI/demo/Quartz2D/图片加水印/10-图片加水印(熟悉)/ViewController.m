//
//  ViewController.m
//  10-图片加水印(熟悉)
//
//  Created by xiaomage on 16/1/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
    //0.加载图片
    UIImage *image = [UIImage imageNamed:@"阿狸头像"];
    //1.开启一个跟图片原始大小的上下文
    //opaque:不透明度
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.把图片绘制到上下文当中
    [image drawAtPoint:CGPointZero];
    //3.把文字绘制到上下文当中
    NSString *str = @"小码哥";
    [str drawAtPoint:CGPointMake(10, 20) withAttributes:nil];
    //4.从上下文当中生成一张图片.(把上下文当中绘制的所有内容,生成一张图片)
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭上下文.
    UIGraphicsEndImageContext();
    
    self.imageV.image = newImage;
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
