//
//  AppDelegate.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/9.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "AppDelegate.h"
#import "XMGRootVc.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

// 自己的事情自己做, 谁的事情谁管理
// 自定义
/*
 1.自定义控制器: 基本都需要自定义,用于处理复杂的逻辑
 2.自定义控件:当系统的控件不能满足需求的时候需要自定, 还原系统的原有的功能,在增加自己的功能
 3. 自定义模型, 系统没有提供模型,所义需要自定义
*/

// 1.让更多的功能复用, 2,节省公司成本 3.方便多人开发

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 2.1设置窗口的跟控制器
    self.window.rootViewController = [XMGRootVc chooseWindowRootVc];
    
    // 3.让窗口显示
    [self.window makeKeyAndVisible];
    
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
