//
//  XMGMyLotteryViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGMyLotteryViewController.h"
#import "XMGSettingTableViewController.h"

@interface XMGMyLotteryViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation XMGMyLotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.设置button的背景图片
    
    // 1.1拿到button的背景图片
    UIImage *image = self.loginBtn.currentBackgroundImage;
    
    // 1.2.拉伸图片
    image =  [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    
    // 1.3.设置背景图片
    [self.loginBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    
    // 2, 设置导航左侧行按钮
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"FBMM_Barbutton"] forState:UIControlStateNormal];
    [button setTitle:@"客服" forState:UIControlStateNormal];
    
    [button sizeToFit];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
   
    // 3, 设置导航右侧行按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithRenderOriginalName:@"Mylottery_config"] style:UIBarButtonItemStylePlain target:self action:@selector(config)];
}

// 导航右侧行按钮点击的时候调用
- (void)config{
//    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    
    XMGSettingTableViewController *setting = [[XMGSettingTableViewController alloc] init];
    
    [self.navigationController pushViewController:setting animated:YES];
//    setting.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
