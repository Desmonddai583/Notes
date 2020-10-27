//
//  ViewController.m
//  05-assign和weak的区别
//
//  Created by xiaomage on 16/3/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

/*
    面试:解释weak,assgin,什么时候使用Weak和assign
    ARC:才有weak 
    weak:__weak 弱指针,不会让引用计数器+1,如果指向对象被销毁,指针会自动清空
    assgin:__unsafe_unretained修饰,不会让引用计数器+1,如果指向对象被销毁,指针不会清空
 */
@property (nonatomic, assign) UIView *redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    
//    [self.view addSubview:view];

    _redView = view;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _redView.frame = CGRectMake(50, 50, 200, 200);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
