//
//  HomeViewController.m
//  06-extern和const联合使用
//
//  Created by xiaomage on 16/3/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "HomeViewController.h"

#import "GlobeConst.h"

@implementation HomeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    

    [[NSUserDefaults standardUserDefaults] setObject:@"321" forKey:discover_name];
    
}

@end
