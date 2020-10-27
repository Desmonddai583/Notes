//
//  XMGRootVC.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/31.
//  Copyright © 2016年 小码哥. All rights reserved.
//
#define XMGVersion @"version"

#import "XMGRootVC.h"
#import "XMGTabBarViewController.h"
#import "XMGNewFeatureCollectionViewController.h"
#import "XMGSaveTool.h"

@implementation XMGRootVC
+ (UIViewController *)chooseWindowRootVC{
    // 当有版本更新,或者第一次安装的时候显示新特性界面;
    // 1.获取当前版本号
    NSString *currVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    //    NSLog(@"%@",currVersion);
    //
    //    // 2.上一次版本号
    //   NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:XMGVersion];
    
    NSString *lastVersion = [XMGSaveTool objectForKey:XMGVersion];
    
    UIViewController *rootVc;
    
    if (![currVersion isEqualToString:lastVersion]) {
        // 进入新特界面
        rootVc = [[XMGNewFeatureCollectionViewController alloc] init];
        //        rootVc.view.backgroundColor = [UIColor yellowColor];
        // 存储当前版本号
        //        [[NSUserDefaults standardUserDefaults] setObject:currVersion forKey:XMGVersion];
        //
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [XMGSaveTool setObject:currVersion forKey:XMGVersion];
        
    }else{
        // 进入主框架
        rootVc = [[XMGTabBarViewController alloc] init];
    }
    
    return rootVc;
}
@end
