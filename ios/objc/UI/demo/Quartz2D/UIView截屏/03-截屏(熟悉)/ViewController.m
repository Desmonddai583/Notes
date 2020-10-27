//
//  ViewController.m
//  03-截屏(熟悉)
//
//  Created by xiaomage on 16/1/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //把控制器的View生成一张图片
    
    //1.开启一个位图上下文(跟当前控制器View一样大小的尺寸)
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    
    //把把控制器的View绘制到上下文当中.
    //2.想要把UIView上面的东西给绘制到上下文当中,必须得要使用渲染的方式.
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.view.layer renderInContext:ctx];
    //[self.view.layer drawInContext:ctx];
    
    //3.从上下文当中生成一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //4.关闭上下文
    UIGraphicsEndImageContext();

    //把生成的图片写入到桌面(文件方式进行传输:二进制流NSData)
    //把图片转成二进制流NSData
    //NSData *data = UIImageJPEGRepresentation(newImage, 1);
     NSData *data = UIImagePNGRepresentation(newImage);
    [data writeToFile:@"/Users/xiaomage/Desktop/newImage.png" atomically:YES];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
