//
//  ViewController.m
//  08-掌握-GCD线程间通信
//
//  Created by xiaomage on 16/2/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //1.创建子线程下载图片
    //DISPATCH_QUEUE_PRIORITY_DEFAULT 0
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        //1.1 确定url
        NSURL *url = [NSURL URLWithString:@"http://a.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=da0ec79c738da9774e7a8e2f8561d42f/c83d70cf3bc79f3d6842e09fbaa1cd11738b29f9.jpg"];
        
        //1.2 下载二进制数据到本地
       NSData *imageData =  [NSData dataWithContentsOfURL:url];
        
        //1.3 转换图片
        UIImage *image = [UIImage imageWithData:imageData];
        
        NSLog(@"download----%@",[NSThread currentThread]);
        
        //更新UI
//        dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
             NSLog(@"UI----%@",[NSThread currentThread]);
        });
        
    });
}

@end
