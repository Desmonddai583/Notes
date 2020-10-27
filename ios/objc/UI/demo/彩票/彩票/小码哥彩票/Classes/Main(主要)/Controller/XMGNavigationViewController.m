//
//  XMGNavigationViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGNavigationViewController.h"
#import <objc/runtime.h>

@interface XMGNavigationViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
/** 系统手势代理 */
@property (nonatomic, strong) id popGesture;
@end

@implementation XMGNavigationViewController
// 什么时候调用 当程序一启动的时候就会调用
// 作用: 将当前类加载进内存, 放在代码区
//+ (void)load{
//    NSLog(@"%s",__func__);
//}
// 什么时候调用 当第一次初始这个类的时候调用,如果当这个类有子类会调用多次
// 作用 初始化这个类
+ (void)initialize{
//    NSLog(@"%s",__func__);
    
    
    if (self == [XMGNavigationViewController class]) {
        // 当前类
        // 1.获取导航条标识
        // 获取APP的导航条标识
        // appearance 是一个协议, 只要遵守了这协议都有这方法
        // 如果这样写有重大bug
        //    UINavigationBar *bar =  [UINavigationBar appearance];
        // Class 获取某几个类的导航条标识
        UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self,nil];
        
        // button
        //    [UIButton appearance];
        //    [UILabel appearance];
        
        //
        [bar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
        
        // 设置字体颜色大小
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        
        //字体大小
        dictM[NSFontAttributeName] = [UIFont boldSystemFontOfSize:22];
        // 字体颜色
        dictM[NSForegroundColorAttributeName] = [UIColor whiteColor];
        
        [bar setTitleTextAttributes:dictM];
        
        
        // 设置导航条前景色
        [bar setTintColor:[UIColor whiteColor]];
        
        //    bar
        // 获取到导航条按钮的标识
        UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
        // 修改返回按钮标题的位置
        [item setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -100) forBarMetrics:UIBarMetricsDefault];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 全屏滑动移除控制器
    /*
     <UIScreenEdgePanGestureRecognizer: 0x7ff934361e20; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7ff93257ace0>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7ff934361390>)>>
     (lldb)
     */
    
    // 1.先修改系统的手势,系统没有给我们提供属性
//    NSLog(@"%@",self.interactivePopGestureRecognizer);
    UIScreenEdgePanGestureRecognizer *gest = self.interactivePopGestureRecognizer;
//    // 2.自己添加手势
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationTransition:)];
//    [self.view addGestureRecognizer:pan];
    
    // 缺Target 系统的私有属性
    // KVC [gest valueForKeyPath:@""];
    // 不知道 Target 真实类型
    // oc  runtime 机制 只能动态获取当前类的成员属性,不能获取其子类,或者父类的属性
    // __unsafe_unretained Class  要获取哪个类的成员属性
    // unsigned int *outCount  获取Class 下面的所有成员属性的个数
//    unsigned int outCount = 0;
//    
//   Ivar *ivars =  class_copyIvarList([UIGestureRecognizer class], &outCount);
//    for (int i = 0; i<outCount; i++) {
////        ivars[i];
//        // 获取成员属性的名字
//     NSString *name = @(ivar_getName(ivars[i]));
//        NSLog(@"%@",name);
//        
//    }
    // (action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fd9db250ce0>)
    
    // _targets
//   NSArray *targets =  [gest valueForKeyPath:@"_targets"];
//    NSLog(@"%@",targets[0]);
//    
//    
//    id target =  [targets[0] valueForKeyPath:@"_target"];
    
//    UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan)];
//    [self.view addGestureRecognizer:pan1];
//    pan1.delegate = self;
//
    id target = self.interactivePopGestureRecognizer.delegate;
//
//    // 2.自己添加手势
//    // 禁止系统的手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    pan.enabled = NO;
    
    [self.view addGestureRecognizer:pan];
    
    pan.delegate = self;
}

#pragma mark - UIGestureRecognizerDelegate
// 当开始滑动的就会调用 如果返回YES ,可以滑动 返回NO,禁止手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    // 当是跟控制器不让移除(禁止), 费根控制器,允许移除控制
//    NSLog(@"%ld",self.viewControllers.count);
    BOOL open = self.viewControllers.count > 1;
    
    return open;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // 当非根控制器隐藏底部tabbar

    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
//    NSLog(@"%ld",self.viewControllers.count);
    
    // 执行这一行代码将控制器压栈
    [super pushViewController:viewController animated:animated];
    
    
}
@end
