//
//  ViewController.m
//  05-掌握-监测网络状态
//
//  Created by xiaomage on 16/2/27.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Reachability.h"

@interface ViewController ()
@property (nonatomic, strong) Reachability *r;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appleReachability) name:kReachabilityChangedNotification object:nil];
    
    Reachability *r = [Reachability reachabilityForLocalWiFi];
    [r startNotifier];
    self.r = r;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

-(void)appleReachability
{
    /*
     NotReachable = 0,
     ReachableViaWiFi,
     ReachableViaWWAN
     */
    //该方法得到一个Reachability类型的蜂窝网络对象
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == ReachableViaWWAN)
    {
        NSLog(@"蜂窝网络");
        return;
    }
    
    if ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == ReachableViaWiFi) {
        NSLog(@"WIFI");
        return;
    }
    
    NSLog(@"没有网络");
}

-(void)afn
{
    
    //1.获得一个网络状态检测管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听状态的改变
    /*
     AFNetworkReachabilityStatusUnknown          = -1, 未知
     AFNetworkReachabilityStatusNotReachable     = 0,  没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,  蜂窝网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2   Wifi
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            default:
                break;
        }
    }];
    
    //3.开始监听
    [manager startMonitoring];
}

@end
