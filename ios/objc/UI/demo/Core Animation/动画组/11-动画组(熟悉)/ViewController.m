//
//  ViewController.m
//  11-动画组(熟悉)
//
//  Created by xiaomage on 16/1/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"position.y";
    anim.toValue = @400;
//    anim.removedOnCompletion = NO;
//    anim.fillMode = kCAFillModeForwards;
//    
//    [self.redView.layer addAnimation:anim forKey:nil];
    
    
    CABasicAnimation *anim2 = [CABasicAnimation animation];
    anim2.keyPath = @"transform.scale";
    anim2.toValue = @0.5;
//    anim2.removedOnCompletion = NO;
//    anim2.fillMode = kCAFillModeForwards;
//    [self.redView.layer addAnimation:anim2 forKey:nil];
    

    CAAnimationGroup *group = [CAAnimationGroup animation];
    //会自动执行animations数组当中所有的动画对象
    group.animations = @[anim,anim2];
    
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [self.redView.layer addAnimation:group forKey:nil];
    
    
    
    
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
