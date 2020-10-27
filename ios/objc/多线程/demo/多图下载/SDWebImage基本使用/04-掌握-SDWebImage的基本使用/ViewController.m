//
//  ViewController.m
//  04-掌握-SDWebImage的基本使用
//
//  Created by xiaomage on 16/2/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"
#import "UIImage+GIF.h"
#import "NSData+ImageContentType.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self download];
}

//1.下载图片且需要获取下载进度
//内存缓存&磁盘缓存
-(void)download
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://img4.duitang.com/uploads/blog/201310/18/20131018213446_smUw4.thumb.600_0.jpeg"] placeholderImage:[UIImage imageNamed:@"Snip20160221_306"] options:SDWebImageCacheMemoryOnly | SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        switch (cacheType) {
            case SDImageCacheTypeNone:
                NSLog(@"直接下载");
                break;
            case SDImageCacheTypeDisk:
                NSLog(@"磁盘缓存");
                break;
            case SDImageCacheTypeMemory:
                NSLog(@"内存缓存");
                break;
            default:
                break;
        }
    }];
    
    NSLog(@"%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]);
    
}

//2.只需要简单获得一张图片,不设置
//内存缓存&磁盘缓存
-(void)download2
{
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:@"http://img4.duitang.com/uploads/blog/201310/18/20131018213446_smUw4.thumb.600_0.jpeg"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        NSLog(@"%f",1.0 * receivedSize / expectedSize);
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        //得到图片
        self.imageView.image = image;
    }];
}

//3.不需要任何的缓存处理
//没有做任何缓存处理|
-(void)download3
{
    //data:图片的二进制数据
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:@"http://img4.duitang.com/uploads/blog/201310/18/20131018213446_smUw4.thumb.600_0.jpeg"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
             self.imageView.image = image;
        }];
       
    }];
}

//4.播放Gif图片
-(void)gif
{
    NSLog(@"%s",__func__);
    //self.imageView.image = [UIImage imageNamed:@"39e805d5ad6eddc4f80259d23bdbb6fd536633ca"];
    
    UIImage *image = [UIImage sd_animatedGIFNamed:@"39e805d5ad6eddc4f80259d23bdbb6fd536633ca"];
    self.imageView.image = image;
}

-(void)type
{
    NSData *imageData = [NSData dataWithContentsOfFile:@"/Users/xiaomage/Desktop/Snip20160221_306.png"];
    NSString *typeStr = [NSData sd_contentTypeForImageData:imageData];
    NSLog(@"%@",typeStr);
}
@end
