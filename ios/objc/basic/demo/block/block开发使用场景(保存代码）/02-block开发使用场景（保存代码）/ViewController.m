//
//  ViewController.m
//  02-block开发使用场景（保存代码）
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

// BlockType:类型别名
typedef void(^BlockType)();

@interface ViewController ()
// block怎么声明,就如何定义成属性
@property (nonatomic, strong) void(^block)();
//@property (nonatomic, strong) BlockType block1;

@end

@implementation ViewController

// 1.在一个方法中定义,在另外一个方法调用
// 2.在一个类中定义,在另外一个类中调用
/*
    1.tableView展示3个cell,打电话,发短信,发邮件
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // void(^)()
    void(^block)() = ^{
        NSLog(@"调用block");
    };
    
    _block = block;
    
}

- (void)test
{
    NSLog(@"调用block");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // block调用:就去寻找保存代码,直接调用
    _block();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
