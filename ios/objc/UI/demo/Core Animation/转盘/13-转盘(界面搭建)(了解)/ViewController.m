//
//  ViewController.m
//  13-转盘(界面搭建)(了解)
//
//  Created by xiaomage on 16/1/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "WheelView.h"

@interface ViewController ()


@property (nonatomic, weak) WheelView *wheelV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    WheelView *wheelV = [WheelView wheelView];
    wheelV.center = self.view.center;
    self.wheelV  = wheelV;
    [self.view addSubview:wheelV];
    
//    WheelView *wheelV = [[WheelView alloc] init];
//    wheelV.center = self.view.center;
//    self.wheelV = wheelV;
//    [self.view addSubview:wheelV];

}

- (IBAction)rotation:(id)sender {
    [self.wheelV rotation];
}

- (IBAction)stop:(id)sender {
    [self.wheelV stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
