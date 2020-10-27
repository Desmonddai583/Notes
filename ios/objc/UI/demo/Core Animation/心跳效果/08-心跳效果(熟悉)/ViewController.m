//
//  ViewController.m
//  08-心跳效果(熟悉)
//
//  Created by xiaomage on 16/1/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //创建动画对象
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    //设置属性值
    anim.keyPath = @"transform.scale";
    anim.toValue = @0;

    //设置动画执行次数
    anim.repeatCount = MAXFLOAT;
    
    //设置动画执行时长
    anim.duration = 3;
    
    //自动反转(怎么样去 怎么样回来)
    anim.autoreverses = YES;
    
    //添加动画
    [self.imageV.layer addAnimation:anim forKey:nil];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
