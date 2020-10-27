//
//  ViewController.m
//  03-UIApplication功能(熟悉)
//
//  Created by xiaomage on 16/1/14.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)bageValue:(id)sender {

    //设置提醒图标
    //1.获取UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    //2.注册用户通知
    UIUserNotificationSettings *notice = [UIUserNotificationSettings settingsForTypes:
                                           UIUserNotificationTypeBadge categories:nil];
    [app registerUserNotificationSettings:notice];
    //3.设置提醒值.
    app.applicationIconBadgeNumber = 10;
}

//设置联网状态
- (IBAction)netState:(id)sender {
    //1.获取UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
}

//设置状态栏
- (IBAction)statueBar:(id)sender {
    //1.获取UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    //隐藏状态栏
    //app.statusBarHidden = NO;
    app.statusBarStyle = UIStatusBarStyleLightContent;
    
    [app setStatusBarHidden:YES animated:YES];
    
    
}
//打开一个URL
- (IBAction)openURL:(id)sender {
    
    //1.获取UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:@"http://www.520it.com"];
    [app openURL:url];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


//状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
//隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
