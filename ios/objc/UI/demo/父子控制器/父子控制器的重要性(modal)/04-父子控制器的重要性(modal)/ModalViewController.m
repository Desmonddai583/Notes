//
//  ModalViewController.m
//  04-父子控制器的重要性(modal)
//
//  Created by xiaomage on 16/3/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ModalViewController.h"
#import "ChildViewController.h"

@interface ModalViewController ()

//@property (nonatomic, strong) ChildViewController *childVc;

@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ChildViewController *childVc = [[ChildViewController alloc] init];
    childVc.view.backgroundColor = [UIColor blueColor];
    childVc.view.frame = CGRectMake(50, 50, 200, 200);
    [self.view addSubview:childVc.view];
    [self addChildViewController:childVc];
//    _childVc = childVc;
    
    // Do any additional setup after loading the view.
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
