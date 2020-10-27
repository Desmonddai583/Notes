//
//  ViewController.m
//  03-block开发使用场景（传值）
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "ModalViewController.h"
/*
 
    传值:1.只要能拿到对方就能传值
 
    顺传:给需要传值的对象,直接定义属性就能传值
    逆传:用代理,block,就是利用block去代替代理
 
 */

@interface ViewController ()// <ModalViewControllerDelegate>

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ModalViewController *modalVc = [[ModalViewController alloc] init];
    modalVc.view.backgroundColor = [UIColor brownColor];
//    modalVc.delegate = self;
    
    modalVc.block = ^(NSString *value) {
      
        NSLog(@"%@",value);
    };
    
    // 跳转
    [self presentViewController:modalVc animated:YES completion:nil];
}

#pragma mark - ModalViewControllerDelegate
// 传值给ViewController
//- (void)modalViewController:(ModalViewController *)modalVc sendValue:(NSString *)value
//{
//    NSLog(@"%@",value);
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

@end
