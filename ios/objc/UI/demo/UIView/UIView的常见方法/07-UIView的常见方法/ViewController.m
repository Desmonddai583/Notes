//
//  ViewController.m
//  07-UIView的常见方法
//
//  Created by xiaomage on 15/12/25.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
// 红色的view
//@property (weak, nonatomic) IBOutlet UIView *redView;

/** 红色的view  */
@property (nonatomic, weak) UIView *redView;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;


@end


/**
 *  尽量少使用tag:
    1> tag的效率非常差
    2> tag使用多了,容易乱
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 根据tag拿到对应的view
    UIView *redView = [self.view viewWithTag:1];
    self.redView = redView;
    
    
   // 1.1 创建UISwitch对象
    UISwitch *sw = [[UISwitch alloc] init];
    
   // 1.2 加到控制器的view中
    [self.view addSubview:sw];
    
    // 1.3 创建UISwitch对象
    UISwitch *sw1 = [[UISwitch alloc] init];
    
    // 1.4 加到红色的view
    [redView addSubview:sw1];
    
    // 1.5 创建一个选项卡对象
    UISegmentedControl *sg = [[UISegmentedControl alloc] initWithItems:@[@"哈哈哈", @"😄", @"嘻嘻"]];
    // 1.6 加到红色的view
    [redView addSubview:sg];
    
    // 1.7 移除
//    [sg removeFromSuperview];
//    [self.redView removeFromSuperview];
//    [sw removeFromSuperview];
    [self.view removeFromSuperview];
    
}

#pragma mark - 伪代码---viewWithTag
/*
- (UIView *)viewWithTag: (NSInteger)tag{
    if (self.tag == tag) return self;
    for (UIView *subView in self.subviews) {
        if (subView.tag == tag)  return subView;
        // 继续递归遍历
        // ..
    }
}
*/

// 只要控件有父控件,就一定能够移除
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.view removeFromSuperview];
}


- (IBAction)remove {
    [self.redView removeFromSuperview];
}

- (IBAction)clickBtn:(UIButton *)button {
    // 做私人的事情
    /*
    if (button == self.btn1) {
        NSLog(@"点击了按钮1");
    }else if (button == self.btn2) {
        NSLog(@"点击了按钮2");
    }else{
        NSLog(@"点击了按钮3");
    }
    */
    
    switch (button.tag) {
        case 3:
            NSLog(@"点击了按钮1");
            break;
        case 4:
            NSLog(@"点击了按钮2");
            break;
        case 5:
            NSLog(@"点击了按钮3");
            break;
        default:
            break;
    }
    
    // 做公共的事情
    NSLog(@"做公共的事情");
}


@end
