//
//  ViewController.m
//  02-Size和center
//
//  Created by xiaomage on 16/3/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/*
 CGRect bounds = redView.bounds;
 bounds.size = CGSizeMake(200, 200);
 redView.bounds = bounds;
 
  frame,bounds
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *redView =[[UIView alloc] init];
    
    redView.backgroundColor = [UIColor redColor];
    
    // center
    redView.center = self.view.center;
    
    // size
    CGRect frame = redView.frame;
    frame.size = CGSizeMake(200, 200);
    redView.frame = frame;
    
    // 如果size,从frame取出来 先设置size,在设置center
    // 如果size,从bounds取出来,就不用考虑center和size区别
    
    [self.view addSubview:redView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
