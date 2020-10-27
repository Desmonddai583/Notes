//
//  XMGTool.m
//  04-掌握-ARC环境下实现单例模式
//
//  Created by xiaomage on 16/2/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTool.h"

@implementation XMGTool

//修改环境为MRC
//0.提供全局变量
static XMGTool *_instance;

//1.alloc-->allocWithZone
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    //加互斥锁解决多线程访问安全问题
//    @synchronized(self) {
//        if (_instance == nil) {
//            _instance = [super allocWithZone:zone];
//        }
//    }
    
    //本身就是线程安全的
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

//2.提供类方法
+(instancetype)shareTool
{
    return [[self alloc]init];
}

//3.严谨
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

#if __has_feature(objc_arc)
//条件满足 ARC
#else
// MRC
-(oneway void)release
{
    
}

-(instancetype)retain
{
    return _instance;
}

//习惯
-(NSUInteger)retainCount
{
    return MAXFLOAT;
}

#endif

@end
