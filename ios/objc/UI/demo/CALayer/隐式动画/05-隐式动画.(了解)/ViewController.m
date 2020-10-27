//
//  ViewController.m
//  05-隐式动画.(了解)
//
//  Created by xiaomage on 16/1/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

/** <#注释#> */
@property (nonatomic, weak)  CALayer *layer;
@property (weak, nonatomic) IBOutlet UIView *redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.frame = CGRectMake(50, 50, 100, 100);
    self.layer = layer;
    [self.view.layer addSublayer:layer];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //只有非根层才有隐式动画,(自己手动创建的图片)
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationDuration:5];
    self.layer.backgroundColor = [UIColor greenColor].CGColor;
    [CATransaction commit];
    
    self.layer.bounds = CGRectMake(0, 0, 90, 90);
    self.layer.backgroundColor = [UIColor greenColor].CGColor;
    self.layer.position = CGPointMake(100, 400);
    
    
    self.redView.layer.position = CGPointMake(300, 400);
    self.redView.layer.bounds = CGRectMake(0, 0, 100, 100);
    self.redView.layer.backgroundColor = [UIColor greenColor].CGColor;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
