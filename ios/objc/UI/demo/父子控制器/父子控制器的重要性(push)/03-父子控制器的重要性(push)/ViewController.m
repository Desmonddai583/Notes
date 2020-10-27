//
//  ViewController.m
//  03-父子控制器的重要性(push)
//
//  Created by xiaomage on 16/3/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "ChildViewController.h"

@interface ViewController ()


//@property (nonatomic, strong) ChildViewController *childVc;

@end

@implementation ViewController
// UIViewController也是可以管理子控制器
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 添加一个子控制器
    ChildViewController *childVc = [[ChildViewController alloc] init];
    childVc.view.backgroundColor = [UIColor greenColor];
    childVc.view.frame = CGRectMake(50, 50, 200, 200);
    [self.view addSubview:childVc.view];
    [self addChildViewController:childVc];
    
    /*
        A:childVc B:ViewController
        开发规划:如果A控制器的view添加到B控制器的view上,那么A控制器必须成为B控制器的子控制器
     */
    
//    _childVc = childVc;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
