//
//  ViewController.m
//  09-音量震动条
//
//  Created by xiaomage on 16/1/27.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //复制层
    CAReplicatorLayer *repL = [CAReplicatorLayer  layer];
    repL.frame = self.contentV.bounds;
    [self.contentV.layer addSublayer:repL];
    
    repL.instanceCount = 5;
    repL.instanceTransform = CATransform3DMakeTranslation(45, 0, 0);
    //设置复制出来的子层动画的延时执行时长
    repL.instanceDelay = 1;
    
    //创建一个振动条
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.bounds = CGRectMake(0, 0, 30, 100);
    layer.anchorPoint = CGPointMake(0, 1);
    layer.position = CGPointMake(0, self.contentV.bounds.size.height);
    [repL addSublayer:layer];
    
    //添加动画
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.scale.y";
    anim.toValue = @0;
    anim.repeatCount = MAXFLOAT;
    anim.duration = 1;
    anim.autoreverses = YES;
    [layer addAnimation:anim forKey:nil];
    
    
    

    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
