//
//  AppDelegate.m
//  07-UIWindow补充(了解)
//
//  Created by xiaomage on 16/1/14.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

/** <#注释#> */
@property (nonatomic, strong)  UITextField *textF;


@property (strong, nonatomic) UIWindow *window1;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //2.设置窗口的根控制器
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    self.window.rootViewController = vc;
    //3.显示窗口
    [self.window makeKeyAndVisible];
    
    
    //从ios9之后,如果添加了多个窗口,控制器它会自动把状态栏给隐藏掉.
    //解决办法,把状态栏给应用程序管理.
    self.window1 = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 375, 20)];
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.view.backgroundColor = [UIColor blueColor];
    self.window1.rootViewController  = vc1;
    [self.window1 makeKeyAndVisible];
    
    //设置窗口层级
    //UIWindowLevelAlert > UIWindowLevelStatusBar > UIWindowLevelNormal
    self.window1.windowLevel = UIWindowLevelStatusBar;
    self.window.windowLevel = UIWindowLevelAlert;
    

    
    //键盘,状态栏其实都是window
    UITextField *textF = [[UITextField alloc] init];
    self.textF = textF;
    [textF becomeFirstResponder];
    //UITextField想要显示键盘,必须得要添加到一个View上,
    [vc.view addSubview:textF];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
