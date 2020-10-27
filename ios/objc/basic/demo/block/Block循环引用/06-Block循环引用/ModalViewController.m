//
//  ModalViewController.m
//  06-Block循环引用
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ModalViewController.h"

@interface ModalViewController ()

@property (nonatomic, strong) void(^block)();

@end

@implementation ModalViewController

- (void)dealloc
{
    NSLog(@"ModalViewController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // block造成循环利用:Block会对里面所有强指针变量都强引用一次
    
    __weak typeof(self) weakSelf = self;
    
    _block = ^{
//        NSLog(@"%@",weakSelf);
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
             NSLog(@"%@",strongSelf);
            
        });
        
    };
    
    _block();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 如果控制器被dismiss就会被销毁
    [self dismissViewControllerAnimated:YES completion:nil];
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
