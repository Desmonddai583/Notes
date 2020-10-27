//
//  XMGViewController.m
//  10-loadView方法(掌握)
//
//  Created by xiaomage on 16/1/14.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGViewController.h"

@interface XMGViewController ()

@end

@implementation XMGViewController


//loadView作用,用来创建控制器的View.
//什么时候调用:当控制器的View,第一次使用的时候调用.

//loadView底层原理:
//1.先判断当前控制器是不是从storyBoard当中加载的,如果是从storyBoard加载的控制器.那么它就会从storyBoard当中加载的控制器的View,设置当前控制器的view.
//2.当前控制器是不是从xib当中加载的,如果是从xib当中加载的话,把xib当中指定的View,设置为当前控制器的View.
//3.如果也不是从xib加载的,它会创建空白的view.

//一但重写了loadView方法,就说明要自己定义View.
//-(void)loadView{
//    
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",self.view);
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
