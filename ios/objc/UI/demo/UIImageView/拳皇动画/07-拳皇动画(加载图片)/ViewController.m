//
//  ViewController.m
//  07-拳皇动画(加载图片)
//
//  Created by xiaomage on 15/12/26.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/** 站立 */
@property (nonatomic, strong) NSArray *standImages;
/** 小招 */
@property (nonatomic, strong) NSArray *smallImages;
/** 大招 */
@property (nonatomic, strong) NSArray *bigImages;

/** 播放器 */
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation ViewController

/**
    图片的两种加载方式:
    1> imageNamed:
      a. 就算指向它的指针被销毁,该资源也不会被从内存中干掉
      b. 放到Assets.xcassets的图片,默认就有缓存
      c. 使用场景:图片经常被使用
 
    2> imageWithContentsOfFile:
      a. 指向它的指针被销毁,该资源会被从内存中干掉
      b. 放到项目中的图片就没有缓存
      c. 使用场景:不经常用,大批量的图片

 */

// 初始化一些数据
- (void)viewDidLoad {
    [super viewDidLoad];
    /*
   self.imageView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(3/255.0) blue:(4/255.0) alpha:0.6];
    return;
     */
    // 1.加载所有的站立图片
    self.standImages = [self loadAllImagesWithimagePrefix:@"stand" count:10];
    
    // 2.加载所有的小招图片
    self.smallImages = [self loadAllImagesWithimagePrefix:@"xiaozhao3" count:39];
    
    // 3.加载所有的大招图片
    self.bigImages = [self loadAllImagesWithimagePrefix:@"dazhao" count:87];
    
    // 4.站立
    [self stand];
    
    // 5.创建播放器
    self.player = [[AVPlayer alloc] init];
}

/**
 *  加载所有的图片
 *
 *  @param imagePrefix 名称前缀
 *  @param count       图片的总个数
 */
- (NSArray *)loadAllImagesWithimagePrefix:(NSString *)imagePrefix count:(int)count{
    NSMutableArray<UIImage *> *images = [NSMutableArray array];
    for (int i=0; i<count; i++) {
        // 获取所有图片的名称
        NSString *imageName = [NSString stringWithFormat:@"%@_%d",imagePrefix, i+1];
        // 创建UIImage
//        UIImage *image = [UIImage imageNamed:imageName];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        // 装入数组
        [images addObject:image];
    }
    return images;
}

/**
 *  站立
 */
- (IBAction)stand {
    /*
    // 2.设置动画图片
    self.imageView.animationImages = self.standImages;
    
    // 3.设置播放次数
    self.imageView.animationRepeatCount = 0;
    
    // 4.设置播放的时长
    self.imageView.animationDuration = 0.6;
    
    // 5.播放
    [self.imageView startAnimating];
    */
    [self palyZhaoWithImages:self.standImages count:0 duration:0.6 isStand:YES musicName:nil];
}

/**
 *  小招
 */
- (IBAction)smallZhao {
    /*
    // 2.设置动画图片
    self.imageView.animationImages = self.smallImages;
    
    // 3.设置动画次数
    self.imageView.animationRepeatCount = 1;
    
    // 4.设置播放时长
    self.imageView.animationDuration = 1.5;
    
    // 5.播放
    [self.imageView startAnimating];
    
    // 6.站立(延迟)
    [self performSelector:@selector(stand) withObject:nil afterDelay:self.imageView.animationDuration];
     */
    [self palyZhaoWithImages:self.smallImages count:1 duration:1.5 isStand:NO musicName:@"xiaozhao3.mp3"];
}

/**
 *  大招
 */
- (IBAction)bigZhao {
    /*
    // 2.设置动画图片
    self.imageView.animationImages = self.bigImages;
    
    // 3.设置动画次数
    self.imageView.animationRepeatCount = 1;
    
    // 4.设置播放时长
    self.imageView.animationDuration = 2.5;
    
    // 5.播放
    [self.imageView startAnimating];
    
    // 6.站立
    [self performSelector:@selector(stand) withObject:nil afterDelay:self.imageView.animationDuration];
    */
    [self palyZhaoWithImages:self.bigImages count:1 duration:2.5 isStand:NO musicName:@"dazhao.mp3"];
}

/**
 *  游戏结束
 */
- (IBAction)gameOver {
    self.standImages = nil;
    self.smallImages = nil;
    self.bigImages = nil;
    
    self.imageView.animationImages = nil;
}


/**
 *  放招
 *
 *  @param images   图片数组
 *  @param count    播放次数
 *  @param duration 播放时间
 *  @param isStand  是否站立
 */
- (void)palyZhaoWithImages:(NSArray *)images count: (NSInteger)count duration:(NSTimeInterval)duration isStand:(BOOL)isStand musicName:(NSString *)musicName{
    // 1.设置动画图片
    self.imageView.animationImages = images;
    
    // 2.设置动画次数
    self.imageView.animationRepeatCount = count;
    
    // 3.设置播放时长
    self.imageView.animationDuration = duration;
    
    // 4.播放
    [self.imageView startAnimating];
    
    // 5.站立
    if (!isStand) {
       // 6.播放
        NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
        [self.player play];
        
        // 7.调节速率
        self.player.rate = 2.0;
        // 延迟执行方法
        [self performSelector:@selector(stand) withObject:nil afterDelay:self.imageView.animationDuration];
    }
}

@end
