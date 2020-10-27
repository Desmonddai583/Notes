//
//  XMGNavigationViewController.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/11.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGNavigationViewController.h"
//#import <objc/runtime.h>

@interface XMGNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation XMGNavigationViewController
// 当程序一启动的时候会调用
// 作用:加载引入的类
//+ (void)load{
//NSLog(@"%s",__func__);
//}

// 当这个类或者子类第一次使用的时候调用
// 初始化一些配置
+ (void)initialize{
    
    if (self == [XMGNavigationViewController class]) { // 当前类
        // 导航条标志
        //    UINavigationBar *bar = [UINavigationBar appearance];
        // appearanceWhenContainedIn获取当前类的标志
        UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
        
        // 其他模式控制器的View是包含导航控制器的尺寸
        [bar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
        
        // 设置导航条字体
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:22];
        dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        [bar setTitleTextAttributes:dict];
        
        // 把返回按钮变成白色
        bar.tintColor = [UIColor whiteColor];
        
        // 把返回按钮的文字移除
        UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
        // Position 位置
        [item setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64) forBarMetrics:UIBarMetricsDefault];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
//<UIScreenEdgePanGestureRecognizer: 0x7f9dfa417fa0; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7f9dfa455760>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7f9dfa454420>)>>
    
//    NSLog(@"%@",self.interactivePopGestureRecognizer);
    UIScreenEdgePanGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    
    // 思路
    // action= handleNavigationTransition:
    // Target
    // KVC  valueForKeyPath
    

// 思路: 缺 Target 可以通过 VC  valueForKeyPath 取出某个类的私有属性 前提是知道这个类Target 的真实属性
    
    // 需要用到oc的运行时
    // 特点: 他只能取出当前类的所有属性,并不能获取他的子类,或者父类的属性
    // UIGestureRecognizer 这个类的属性
    // Class: 获取那个累的成员属性
    // outCount: 获取这个类的属性的个数
//    unsigned int outCount = 0;
//    
//    Ivar *ivars = class_copyIvarList([UIGestureRecognizer class], &outCount);
//    for (int i = 0; i < outCount; i++) {
//        NSString *name =  @(ivar_getName(ivars[i]));
//        NSLog(@"%@",name);
//        
//    }
    NSArray *targets = [gesture valueForKeyPath:@"_targets"];
//    NSLog(@"%@",targets[0]);
    // 取出target
    id target = [targets[0] valueForKeyPath:@"_target"];
    
    // 禁止系统的
    self.interactivePopGestureRecognizer.enabled = NO;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
}
#pragma mark - UIGestureRecognizerDelegate
// 返回YES收拾可以交互, 返回NO不能交互
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    NSLog(@"%ld",self.childViewControllers.count);
    // != 1 非跟控制器 > 1
    return self.childViewControllers.count > 1;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) { // 非跟控制器就隐藏底部TabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
