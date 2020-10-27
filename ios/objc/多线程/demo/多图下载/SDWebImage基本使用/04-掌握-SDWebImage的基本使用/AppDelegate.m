//
//  AppDelegate.m
//  04-掌握-SDWebImage的基本使用
//
//  Created by xiaomage on 16/2/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "AppDelegate.h"
#import "SDWebImageManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    //1.清空缓存
    //clear:直接删除缓存目录下面的文件,然后重新创建空的缓存文件
    //clean:清除过期缓存,计算当前缓存的大小,和设置的最大缓存数量比较,如果超出那么会继续删除(按照文件了创建的先后顺序)
    //过期时间:7天
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    
    //2.取消当前所有的操作
    [[SDWebImageManager sharedManager] cancelAll];
    
    //3.最大并发数量 == 6
    //4.缓存文件的保存名称如何处理? 拿到图片的URL路径,对该路径进行MD5加密
    //5.该框架内部对内存警告的处理方式? 内部通过监听通知的方式请你缓存
    //6.该框架进行缓存处理的方式:可变字典--->NSCache
    //7.如何判断图片的类型: 在判断图片类型的时候，只匹配第一个字节
    //8.队列中任务的处理方式:FIFO
    //9.如何下载图片的? 发送网络请求下载图片,NSURLConnection
    //10.请求超时的时间 15秒
    
    //[NSData dataWithContentsOfURL:<#(nonnull NSURL *)#>]
}
@end
