//
//  MyViewController.m
//  抽屉效果使用
//
//  Created by xiaomage on 16/1/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "MyViewController.h"
#import "TableViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //当一个控制器的View添加到另一个控制器的View上的时候,那此时View所在的控制器也应该成为上一个控制器的子控制器.
    TableViewController *vc1 = [[TableViewController alloc] init];
    vc1.view.frame = self.mainV.bounds;
    [self.mainV addSubview:vc1.view];
    [self addChildViewController:vc1];
    
    
    TableViewController *vc2 = [[TableViewController alloc] init];
    vc2.view.backgroundColor = [UIColor redColor];
    vc2.view.frame = self.mainV.bounds;
    [self.leftV addSubview:vc2.view];
    [self addChildViewController:vc2];
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
