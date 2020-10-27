//
//  ViewController.m
//  04-iOS9新特性之__kindof
//
//  Created by xiaomage on 16/3/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "SubPerson.h"

/*
    kindof:相当于
 
    __kindof:表示当前类或者它的子类'
 
    类设计历史
 
    id:可以调用任何对象方法,不能进行编译检查
 */

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     SubPerson *p = [SubPerson person];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
