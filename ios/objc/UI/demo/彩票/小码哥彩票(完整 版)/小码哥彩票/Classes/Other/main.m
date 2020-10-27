//
//  main.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/9.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//main -> UIApplicationMain
// 1.UIApplicationMain 对象
// 2.UIApplicationMain 对象的代理
// 3.开启主运行循环, 保证我们程序一直运行
// 4.加载info.plist 文件

int main(int argc, char * argv[]) {
//    NSLog(@"%s",__func__);
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
