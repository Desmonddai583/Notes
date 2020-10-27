//
//  XMGArenaNavViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/30.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGArenaNavViewController.h"

@interface XMGArenaNavViewController ()

@end

@implementation XMGArenaNavViewController

+ (void)initialize{
    
    
    // 1.获取导航条标识
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    // 2.设置导航条背景图片
    // 2.1拉伸图片
    UIImage *image =  [UIImage imageNamed:@"NLArenaNavBar64"];
    image =  [image stretchableImageWithLeftCapWidth:image.size.width /2 topCapHeight:image.size.height /2];
    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    
}

@end
