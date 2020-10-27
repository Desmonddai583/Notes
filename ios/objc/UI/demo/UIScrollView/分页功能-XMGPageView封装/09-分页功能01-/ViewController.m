//
//  ViewController.m
//  09-分页功能01-
//
//  Created by xiaomage on 16/1/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGPageView.h"

@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XMGPageView *pageView = [XMGPageView pageView];
    pageView.backgroundColor = [UIColor redColor];
    
    
    pageView.imageNames = @[@"img_01",@"img_02",@"img_03",@"img_04",@"img_05"];
    
    pageView.frame = CGRectMake(0, 20, 320, 150);
    [self.view addSubview:pageView];
}


@end
