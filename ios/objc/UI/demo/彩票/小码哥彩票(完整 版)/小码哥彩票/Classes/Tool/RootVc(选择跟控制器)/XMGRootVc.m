//
//  XMGRootVc.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/13.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGRootVc.h"
#import "XMGTabBarViewController.h"
#import "XMGNewFeatreCollectionViewController.h"
#import "XMGSaveTool.h"

@implementation XMGRootVc
+ (UIViewController *)chooseWindowRootVc{
#define XMGVerson @"Verson"
    
    UIViewController *rootVc;
    // 取出当前版本
    NSString *currVerson = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    // 取出上一次保存的版本
    NSString *odlVerson = [XMGSaveTool objectForKey:XMGVerson];
    
    
    // 1.1 1.2 1.3
//    if ([currVerson isEqualToString:odlVerson]) { // 没有新版本, 进入主框架
//        // 2.设置窗口的跟控制器
//        rootVc = [[XMGTabBarViewController alloc] init];
//    }else{
//        //有新版本
//        // 显示新特性界面
//        
//        rootVc = [[XMGNewFeatreCollectionViewController alloc] init];
//        
//        [XMGSaveTool setObject:currVerson forKey:XMGVerson];
//    }
    rootVc = [[XMGNewFeatreCollectionViewController alloc] init];
    return rootVc;
}
@end
