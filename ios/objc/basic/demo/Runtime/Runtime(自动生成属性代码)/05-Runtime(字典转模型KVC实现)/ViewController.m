//
//  ViewController.m
//  05-Runtime(字典转模型KVC实现)
//
//  Created by xiaomage on 16/3/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "NSDictionary+Property.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 获取文件全路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"status.plist" ofType:nil];
    
    // 文件全路径
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    // 设计模型,创建属性代码 => dict
    [dict createPropertyCode];
    
    // 字典转模型
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
