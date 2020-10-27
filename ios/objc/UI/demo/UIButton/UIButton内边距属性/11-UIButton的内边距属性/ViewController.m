//
//  ViewController.m
//  11-UIButton的内边距属性
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置按钮的内边距
    //1.设置内容
//    self.button.contentEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    // 2.设置图片
     self.button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // 3.设置标题
    self.button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
}

@end
