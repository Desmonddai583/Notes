//
//  ViewController.m
//  09-手势识别(点按,长按,轻扫)
//
//  Created by xiaomage on 16/1/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //1.创建手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    //设置轻扫的方向(一个轻扫手势只能对应一个方向)
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    //设置轻扫的方向(一个轻扫手势只能对应一个方向)
    swipe1.direction = UISwipeGestureRecognizerDirectionRight;

    
    //2.添加手势
    [self.imageV addGestureRecognizer:swipe];
    [self.imageV addGestureRecognizer:swipe1];
}


//当轻扫时调用
- (void)swipe:(UISwipeGestureRecognizer *)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"left");
    }else if(swipe.direction == UISwipeGestureRecognizerDirectionRight){
        NSLog(@"right");
    }
    
    //NSLog(@"%s",__func__);
}




//长按手势
- (void)longP{
    //1.创建手势
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longP:)];
    
    //2.添加手势
    [self.imageV addGestureRecognizer:longP];
}


//当长按时调用(当长按移动时,该方法会持续调用)
- (void)longP:(UILongPressGestureRecognizer *)longP{
    NSLog(@"%s",__func__);
    //判断手势的状态
    if (longP.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始长按");
    }else if(longP.state == UIGestureRecognizerStateChanged){
         NSLog(@"长按时移动");
    }else if(longP.state == UIGestureRecognizerStateEnded){
        NSLog(@"手指离开");
    }
    
}





//点按手势
- (void)setUpTap{

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    
    tap.delegate = self;
    
    //2.添加手势
    [self.imageV addGestureRecognizer:tap];
    
}




//3.实现手势方法
- (void)tap{
    
    NSLog(@"%s",__func__);
}


//是否允许接收手指.
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    //让当前的图片,左边不能点击 ,右边能够点击
    //获取当前手指的点
//    CGPoint curP = [touch locationInView:self.imageV];
//    
//    if (curP.x > self.imageV.frame.size.width * 0.5) {
//        //在右边
//        return YES;
//    }else{
//        //在左边
//        return NO;
//    }
//    
//
//}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
