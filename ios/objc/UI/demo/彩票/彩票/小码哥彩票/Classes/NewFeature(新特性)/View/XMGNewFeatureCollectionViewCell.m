//
//  XMGNewFeatureCollectionViewCell.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/30.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGNewFeatureCollectionViewCell.h"
#import "XMGTabBarViewController.h"

@interface XMGNewFeatureCollectionViewCell()

/** 背景图片 */
@property (nonatomic, weak) UIImageView *bgImageView;

/** 立即体验按钮 */
@property (nonatomic, weak) UIButton *startBtn;
@end

@implementation XMGNewFeatureCollectionViewCell


- (UIButton *)startBtn{
    if (!_startBtn) {
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageNamed:@"guideStart"] forState:UIControlStateNormal];
        [button sizeToFit];
        
        
        button.center = CGPointMake(self.width / 2, self.height * 0.9f);
        
        [self.contentView addSubview:button];
        _startBtn = button;
        
        [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside ];
        
    }
    return _startBtn;
}
// 点击立即体验按钮的时候就会调用
- (void)buttonOnClick:(UIButton *)button{
//    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    // 切换主界面
    // 切换界面方式  1.push 2.tabBarVC  3.modale
    
    // 想让新特性界面销毁
    
    // 切换窗口的跟控制器
    XMGTabBarViewController *tabBarVC = [[XMGTabBarViewController alloc] init];
    
    XMGKeyWindow.rootViewController =  tabBarVC;
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:imageView];
        _bgImageView = imageView;
    }
    return _bgImageView;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    
    self.bgImageView.image = image;
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count{
    if (indexPath.item == count - 1 ) {
        // 最后一个cell
        // 当是最后一个cell添加立即体验按钮
        //        UIButton *button
        // 显示
        self.startBtn.hidden = NO;
        
    }else{
        // 不是最后一cell
        //        隐藏立即体验按钮
        self.startBtn.hidden = YES;
    }
}
@end
