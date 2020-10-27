//
//  AppDelegate.m
//  06-UIWindow(掌握)
//
//  Created by xiaomage on 16/1/14.
//  Copyright © 2016年 小码哥. All rights reserved.
//


//1.如果有Main,它会加载Main.storyBoard.
//2.先创建一个窗口
//3.把Main.storyBoard.箭头指向的控制器,设为窗口的根控制器.
//4.显示窗口(把窗口的根控制器的View,添加到窗口)


#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //1.创建窗口
    self.window = [[UIWindow  alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blueColor];
    
    
    //2.一个窗口必须得有根控制器(设置窗口的根控制器)
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    self.window.rootViewController = vc;
    
    //NSLog(@"%@",[UIApplication sharedApplication].keyWindow);
    NSLog(@"%@",self.window);
    //3.显示
   //[self.window makeKeyAndVisible];
   //NSLog(@"%@",[UIApplication sharedApplication].keyWindow);
    NSLog(@"%@",self.window);
    NSLog(@"%@",self.window.subviews);
    self.window.hidden = NO;
    NSLog(@"%@",self.window.subviews);
    /**
     makeKeyAndVisible:
     1.设置应用程序的主窗口
     2.让窗口显示,把窗口hidden = no,显示过程当中,把窗口的根控制器的view添加到窗口上.
     [self.window addsubView:rootViewCotroller.view]
     */
        
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
