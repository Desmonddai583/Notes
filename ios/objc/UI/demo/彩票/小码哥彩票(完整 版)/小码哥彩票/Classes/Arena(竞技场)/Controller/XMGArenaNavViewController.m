//
//  XMGArenaNavViewController.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/12.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGArenaNavViewController.h"

@interface XMGArenaNavViewController ()

@end

@implementation XMGArenaNavViewController

+ (void)initialize{
    
    // 1.获取当前导航控制的标志
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
 
    // 拉伸图片
    UIImage *image = [UIImage stretchableImageName:@"NLArenaNavBar64"] ;
//   image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5f topCapHeight:image.size.height * 0.5f];
    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

}


@end
