//
//  ViewController.m
//  10-转场动画(熟悉)
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

    
    
  
 
    
    
}

static int _i = 1;
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    

    
    //转场代码与转场动画必须得在同一个方法当中.
    
    //转场代码
//    _i++;
//    if (_i == 4) {
//        _i = 1;
//    }
//    
//    NSString *imageName = [NSString stringWithFormat:@"%d",_i];
//    self.imageV.image = [UIImage imageNamed:imageName];
//
//    
//    //添加转场动画
//    CATransition *anim = [CATransition animation];
//    anim.duration  = 1;
//    //设置转场的类型
//    anim.type = @"pageCurl";
//    
//    //设置动画的起始位置
//    anim.startProgress = 0.3;
//    //设置动画的结束位置
//    anim.endProgress = 0.5;
//    
//    
//    
//    [self.imageV.layer addAnimation:anim forKey:nil];
    
    
    
//    
    
    [UIView transitionWithView:self.imageV duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        
        //转场 代码
        _i++;
        if (_i == 4) {
            _i = 1;
        }
        
        NSString *imageName = [NSString stringWithFormat:@"%d",_i];
        self.imageV.image = [UIImage imageNamed:imageName];
    } completion:^(BOOL finished) {
        
    }];

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
