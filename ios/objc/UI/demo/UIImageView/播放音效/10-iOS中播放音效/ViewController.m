//
//  ViewController.m
//  10-iOS中播放音效
//
//  Created by xiaomage on 15/12/26.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
/**
 *  背景图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

/** 播放器 */
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.加毛玻璃
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    
    // 2. 设置frame
    toolbar.frame = self.bgImageView.bounds;
    
    // 3. 设置样式和透明度
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.alpha = 0.98;
    
    // 4.加到背景图片上
    [self.bgImageView addSubview:toolbar];
    
    // 5.创建播放器
    /*
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mySong1.mp3" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
     */
    // 资源的URL地址
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"mySong1.mp3" withExtension:nil];
    // 创建播放器曲目
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    // 创建播放器
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    
}

/**
 *  播放/暂停
 *
 *  @param button 按钮
 */
- (IBAction)playOrPause:(UIButton *)button {
    switch (button.tag) {
        case 3:
            [self.player play]; // 播放
            break;
        case 4:
            [self.player pause]; // 暂停
            break;
        default:
            break;
    }
}

/**
 *  切换歌曲
 *
 *  @param button 按钮
 */
- (IBAction)changeMusic:(UIButton *)button {
    // 歌曲的名称
    NSString *musicName = nil;
    switch (button.tag) {
        case 1:// 上一首
            musicName = @"mySong2.mp3";
            break;
        case 2:// 下一首
            musicName = @"mySong3.mp3";
            break;
        default:
            break;
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    
    // 播放
    [self.player play];
}



@end
