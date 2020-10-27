//
//  ViewController.m
//  06-Block循环引用
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "ModalViewController.h"

/*
    循环引用:我引用你,你也引用,就会造成循环引用,双方都不会被销毁,导致内存泄露问题
 
*/

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ModalViewController *modalVc = [[ModalViewController alloc] init];
    modalVc.view.backgroundColor = [UIColor greenColor];
    [self presentViewController:modalVc animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
