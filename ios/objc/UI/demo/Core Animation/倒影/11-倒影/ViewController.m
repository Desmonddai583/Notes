//
//  ViewController.m
//  11-倒影
//
//  Created by xiaomage on 16/1/27.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"%@",self.view.layer);
    CAReplicatorLayer *repL =  (CAReplicatorLayer *)self.view.layer;
    repL.instanceCount = 2;
    //绕着复制层的锚点进行旋转
    repL.instanceTransform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    
    //阴影
    repL.instanceRedOffset -= 0.1;
    repL.instanceGreenOffset -= 0.1;
    repL.instanceBlueOffset -= 0.1;
    repL.instanceAlphaOffset -= 0.1;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
