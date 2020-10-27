//
//  ViewController.m
//  13-modal
//
//  Created by xiaomage on 16/1/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "TwoViewController.h"

@interface ViewController ()


/** <#注释#> */
@property (nonatomic, strong) UIViewController *twoVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    

    
    
}

- (IBAction)modal:(id)sender {
    
    
    NSLog(@"%@",self.presentedViewController);
    
    
    TwoViewController *twoVC = [[TwoViewController alloc] init];
    //当在modal时,会把窗口上面的View给移除,然后要modal控制器的view,给添加到窗口上.
    
    //如果当一个控制器被销毁,那么它View的业务逻辑是没有办法处理.
    //控制器被销毁,控制器的View不一定被销毁(只要有强指针指向它,就不会被销毁);
//    [self presentViewController:twoVC animated:YES completion:^{
////        NSLog(@"modal completion");
////        
//     NSLog(@"%@",[UIApplication sharedApplication].keyWindow.rootViewController);
//        
//     NSLog(@"%@",self.presentedViewController);
//        
//    }];
    
    
    CGRect frame = twoVC.view.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    twoVC.view.frame = frame;
    [[UIApplication sharedApplication].keyWindow addSubview:twoVC.view];
    
    self.twoVC = twoVC;
    
    
    [UIView animateWithDuration:0.5 animations:^{
       
        twoVC.view.frame = self.view.frame;
        
    }completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
