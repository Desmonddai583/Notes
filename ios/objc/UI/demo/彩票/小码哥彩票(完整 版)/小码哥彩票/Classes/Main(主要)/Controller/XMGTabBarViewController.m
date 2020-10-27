//
//  XMGTabBarViewController.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/10.
//  Copyright © 2015年 simplyou. All rights reserved.
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
/**
 *  所有item模型
 */
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
    
    /*
     tabBar image 图片大小不能超过60px ,如果超过60px,就不会显示
     解决办法: 1. 找产品经理协商,该需求, 大公司直接找老大, 小公司找PM (需求定下来一般不会改);
     2.自己想办法;
        2.1.自定义
        2.1.1 移除系统TabBar 添加自己的TabBar(简单粗暴)
        2.1.2 移除系统TabBar 子控件,添加自己的控件
     */
    // 1.添加所有的自控制器
    [self setupAllChildController];
 
    // 2.添加tabBar
    [self setupTabBar];

}
#pragma mark - 添加tabBar
- (void)setupTabBar{
    //  2. 移除系统TabBar 添加自己的TabBar(简单粗暴)
//    [self.tabBar removeFromSuperview];
    /*
     添加自己的TabBar UIView
     1.添加button
     2.如何切换控制器 selectedIndex
     */
    
    //    self.selectedIndex = 1;
    
    XMGTabBar *tabBar = [[XMGTabBar alloc] initWithFrame:self.tabBar.bounds];
    tabBar.delegate = self;
    tabBar.items = self.items;
    tabBar.backgroundColor = [UIColor yellowColor];
    [self.tabBar addSubview:tabBar];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    2.1.2 移除系统TabBar 子控件,添加自己的控件
    // UITabBarButton 私有属性

    
    for (UIView *view in self.tabBar.subviews) {
//        NSLog(@"%@",view);
        // 1.方法 hasPrefix 判断是否以这个前缀开头
        // hasSuffix 判断后缀
//        NSString *classString = NSStringFromClass([view class]);
//        if ([classString hasPrefix:@"UITabBarButton"]) {
//            [view removeFromSuperview];
//        }
        
        // 2.方法 思路:子类是私有的看父类是否是私有的,
//        NSLog(@"%@",view.superclass);
//        if ([view isKindOfClass:[UIControl class]]) {
//            [view removeFromSuperview];
//        }
        
        // 3. 逆向思维 判断如果不是 XMGTabBar就移除
        if (![view isKindOfClass:[XMGTabBar class]]) {
            [view removeFromSuperview];
        }
    }
}
#pragma mark - XMGTabBarDelegate
- (void)tabBar:(XMGTabBar *)tabBar index:(NSInteger)index{
//    NSLog(@"%ld",index);
    // 切换控制器
    self.selectedIndex = index;
}
/**
 *  添加所有的自控制器
 */
#pragma mark - 添加所有的自控制器
- (void)setupAllChildController{
    // 1.购彩大厅
    XMGHallTableViewController *hall = [[XMGHallTableViewController alloc] init];
    //    hall.tabBarItem.title = @"购彩大厅";
    [self setupOneChildController:hall image:[UIImage imageNamed:@"TabBar_Hall_new"] seleImage:[UIImage imageNamed:@"TabBar_Hall_selected_new"]title:@"购彩大厅"];
    
    // 2.竞技场
    XMGArenaViewController *arena = [[XMGArenaViewController alloc] init];
    [self setupOneChildController:arena image:[UIImage imageNamed:@"TabBar_Arena_new"] seleImage:[UIImage imageNamed:@"TabBar_Arena_selected_new"] title:@"竞技场"];
    
    
    // 3.发现
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"XMGDiscoverTableViewController" bundle:nil];
    
    
    XMGDiscoverTableViewController *discover = [storyboard instantiateInitialViewController];
    
    [self setupOneChildController:discover image:[UIImage imageNamed:@"TabBar_Discovery_new"] seleImage:[UIImage imageNamed:@"TabBar_Discovery_selected_new"] title:@"发现"];
    
    // 4.开奖信息
    XMGHistoryTableViewController *history = [[XMGHistoryTableViewController alloc] init];
    [self setupOneChildController:history image:[UIImage imageNamed:@"TabBar_History_new"] seleImage:[UIImage imageNamed:@"TabBar_History_selected_new"] title:@"开奖信息"];
    
    // 5.我的彩票
    XMGMyLotteryViewController *myLottery = [[XMGMyLotteryViewController alloc] init];
    [self setupOneChildController:myLottery image:[UIImage imageNamed:@"TabBar_MyLottery_new"] seleImage:[UIImage imageNamed:@"TabBar_MyLottery_selected_new"] title:@"我的彩票"];
}
// 添加一个自控制器
- (void)setupOneChildController:(UIViewController *)vc image:(UIImage *)image seleImage:(UIImage *)seleImage title:(NSString *)title{
    
    // 包装导航控制器
    UINavigationController *nav = [[XMGNavigationViewController alloc] initWithRootViewController:vc];
    if ([vc isKindOfClass:[XMGArenaViewController class]]){
        nav = [[XMGArenaNavViewController alloc] initWithRootViewController:vc];
    }
   
    [self addChildViewController:nav];
    // 导航控制的标题有栈顶控制器决定
    //    vc.navigationItem.title = title;
    vc.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = seleImage;
    [self.items addObject:vc.tabBarItem];
}
@end
