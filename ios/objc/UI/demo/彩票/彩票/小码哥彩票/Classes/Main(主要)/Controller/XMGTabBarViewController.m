//
//  XMGTabBarViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTabBarViewController.h"

#import "XMGHallTableViewController.h"
#import "XMGArenaViewController.h"
#import "XMGDiscoverTableViewController.h"
#import "XMGHistoryTableViewController.h"
#import "XMGMyLotteryViewController.h"

#import "XMGTabBar.h"
#import "XMGNavigationViewController.h"
#import "XMGArenaNavViewController.h"

@interface XMGTabBarViewController ()<XMGTabBarDelegate>
/** taBBar item 模型数组 */
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation XMGTabBarViewController
- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.添加子控制器
    [self setupAllChildViewController];
    
//    self.selectedIndex = 1;
//    NSLog(@"%@",self.tabBar.subviews);
    
    // 2.自定义tabBar
    [self setupTabBar];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 移除系统的tabbar的子控件 UITabBarButton
    // UITabBarButton 是私有属性
    for (UIView *view in self.tabBar.subviews) {
//        NSLog(@"%@",view);
// 逆向思维判断一下当前点控件是不是XMGTabBar,如果不是直接移除
        if (![view isKindOfClass:[XMGTabBar class]]) {
            [view removeFromSuperview];
        }
    }
}
// 自定义tabBar
- (void)setupTabBar{
    /*
     // 1.移除(简单粗暴)
     1.tabBar UIView
     2.UIButton
     3.切换自控制 selectedIndex
     */
    // 1.移除系统的tabBar
//    [self.tabBar removeFromSuperview];
    
    // 2.添加自己的tabBar
    XMGTabBar *tabBar = [[XMGTabBar alloc] init];
//    tabBar.count = self.childViewControllers.count;
    tabBar.items = self.items;

    [self.tabBar addSubview:tabBar];
    tabBar.frame = self.tabBar.bounds;
    tabBar.backgroundColor = [UIColor redColor];
    tabBar.delegate = self;
    
    
    // 1.子控制器的个数
    // 2.UIButton 内容
    
//    NSLog(@"%@",NSStringFromCGSize(self.tabBar.frame.));
//    NSLog(@"%@",NSStringFromCGRect(self.tabBar.frame));
    
    
}

#pragma mark - XMGTabBarDelegate
- (void)tabBar:(XMGTabBar *)tabBar index:(NSInteger)index{
//    NSLog(@"%ld",index);
    // 切换子控制器
    self.selectedIndex = index;
    
}
// 添加所有的子控制器
- (void)setupAllChildViewController{
    
     // 怎么解
    // 1.找UI妹子调整图片, 项目负责, PM
    // 2.自定义
   
    /*
     // 1.移除(简单粗暴)
     1.tabBar UIView
     2.UIButton
     3.切换自控制 selectedIndex
    */
    // 2.移除tabBar子控件
    
    
    // tabBarItem 模型 , 对应子控制器的tabBarItem 决定
    // 1.购彩大厅
    XMGHallTableViewController *hall = [[XMGHallTableViewController alloc] init];
//    hall.view.backgroundColor = [UIColor yellowColor];
    
    [self setupOneChildViewController:hall image:[UIImage imageNamed:@"TabBar_Hall_new"] selImage:[UIImage imageNamed:@"TabBar_Hall_selected_new"] title:@"购彩大厅"];
    
//    [self.items addObject:hall.tabBarItem];
    
    // 2.竞技场
    XMGArenaViewController *arena = [[XMGArenaViewController alloc] init];
//    arena.view.backgroundColor =[UIColor greenColor];
    
    [self setupOneChildViewController:arena image:[UIImage imageNamed:@"TabBar_Arena_new"] selImage:[UIImage imageNamed:@"TabBar_Arena_selected_new"] title:nil];
    
    // 3.发现
    // 3.1加载storyboard
   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"XMGDiscoverTableViewController" bundle:nil];
    
    // 3.2初始化箭头指向的控制器
    XMGDiscoverTableViewController *discover = [storyboard instantiateInitialViewController];
    
//    XMGDiscoverTableViewController *discover = [[XMGDiscoverTableViewController alloc] init];
//    discover.view.backgroundColor  = [UIColor orangeColor];
    
    [self setupOneChildViewController:discover image:[UIImage imageNamed:@"TabBar_Discovery_new"] selImage:[UIImage imageNamed:@"TabBar_Discovery_selected_new"] title:@"发现"];
    
    // 4.开奖信息
    XMGHistoryTableViewController *history = [[XMGHistoryTableViewController alloc] init];
//    history.view.backgroundColor = [UIColor blueColor];
    
    [self setupOneChildViewController:history image:[UIImage imageNamed:@"TabBar_History_new"] selImage:[UIImage imageNamed:@"TabBar_History_selected_new"] title:@"开奖信息"];
    
    // 5.我的彩票
    XMGMyLotteryViewController *myLottery = [[XMGMyLotteryViewController alloc] init];
//    myLottery.view.backgroundColor = [UIColor purpleColor];
    
    [self setupOneChildViewController:myLottery image:[UIImage imageNamed:@"TabBar_MyLottery_new"] selImage:[UIImage imageNamed:@"TabBar_MyLottery_selected_new"] title:@"我的彩票"];
}

// 添加一个子控制器
- (void)setupOneChildViewController:(UIViewController *)vc image:(UIImage *)image selImage:(UIImage *)selImage title:(NSString *)title{
    
    // 包装成导航控制器
    // 1.创建导航控制器
    UINavigationController *nav = [[XMGNavigationViewController alloc] initWithRootViewController:vc];
    
    if ([vc isKindOfClass:[XMGArenaViewController class]]) {
        //竞技场
        nav = [[XMGArenaNavViewController alloc] initWithRootViewController:vc];
    }
    
    [self addChildViewController:nav];
    
    // 导航控制器上的内容有栈顶控制器navigationItem
    vc.navigationItem.title = title;

    
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selImage;
//    vc.tabBarItem.title =
    [self.items addObject:vc.tabBarItem];
}
@end
