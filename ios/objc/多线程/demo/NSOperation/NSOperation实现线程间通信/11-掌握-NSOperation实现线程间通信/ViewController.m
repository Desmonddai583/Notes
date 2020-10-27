//
//  ViewController.m
//  11-掌握-NSOperation实现线程间通信
//
//  Created by xiaomage on 16/2/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self comBie];
}

-(void)download
{
    
    //http://s15.sinaimg.cn/bmiddle/4c0b78455061c1b7f1d0e
    
    //1.开子线程下载图片
    //1.1 非主队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    //1.2 封装操作
    NSBlockOperation *download = [NSBlockOperation blockOperationWithBlock:^{
        
        NSURL *url = [NSURL URLWithString:@"http://s15.sinaimg.cn/bmiddle/4c0b78455061c1b7f1d0e"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        
        NSLog(@"download---%@",[NSThread currentThread]);
        
        //3.更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = image;
            NSLog(@"UI---%@",[NSThread currentThread]);
        }];
        
    }];
    
    //2.添加操作到队列
    [queue addOperation:download];
}

/*
 1.下载图片1
 2.下载图片2
 3.合并图片
 */
-(void)comBie
{
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    __block UIImage *image1;
    __block UIImage *image2;
    //2 封装操作,下载图片1
    NSBlockOperation *download1 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSURL *url = [NSURL URLWithString:@"http://s15.sinaimg.cn/bmiddle/4c0b78455061c1b7f1d0e"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        image1 = [UIImage imageWithData:imageData];
        
        NSLog(@"download---%@",[NSThread currentThread]);
        
    }];
    
    //3 封装操作,下载图片2
    NSBlockOperation *download2 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSURL *url = [NSURL URLWithString:@"http://www.027art.com/feizhuliu/UploadFiles_6650/201109/2011091718442835.jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        image2 = [UIImage imageWithData:imageData];
        
        NSLog(@"download---%@",[NSThread currentThread]);
        
    }];
    
    //4.封装合并图片的操作
    NSBlockOperation *combie = [NSBlockOperation blockOperationWithBlock:^{
        //4.1 开上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        
        //4.2 画图1
        [image1 drawInRect:CGRectMake(0, 0, 100, 200)];
        
        //4.3 画图2
        [image2 drawInRect:CGRectMake(100, 0, 100, 200)];
        
        //4.4 根据上下文得到图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        //4.5 关闭上下文
        UIGraphicsEndImageContext();
        
        //7.更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = image;
            NSLog(@"UI----%@",[NSThread currentThread]);
        }];
        
    }];
    
    //5.设置依赖关系
    [combie addDependency:download1];
    [combie addDependency:download2];
    
    //6.添加操作到队列中
    [queue addOperation:download2];
    [queue addOperation:download1];
    [queue addOperation:combie];
}
@end
