//
//  ViewController.m
//  05-掌握-NSCache的基本使用
//
//  Created by xiaomage on 16/2/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSCacheDelegate>
/** 注释 */
@property (nonatomic, strong) NSCache *cache;
@end

@implementation ViewController

-(NSCache *)cache
{
    if (_cache == nil) {
        _cache = [[NSCache alloc]init];
        _cache.totalCostLimit = 5;//总成本数是5 ,如果发现存的数据超过中成本那么会自动回收之前的对象
        _cache.delegate = self;
    }
    return _cache;
}

//存数据
- (IBAction)addBtnClick:(id)sender
{
    //NSCache的Key只是对对象进行Strong引用，不是拷贝(和可变字典的区别)
    for (NSInteger i = 0; i<10; i++) {
       NSData *data = [NSData dataWithContentsOfFile:@"/Users/xiaomage/Desktop/Snip20160221_38.png"];
        
        //cost:成本
        [self.cache setObject:data forKey:@(i) cost:1];
        NSLog(@"存数据%zd",i);
    }
}

//取数据
- (IBAction)checkBtnClick:(id)sender
{
    NSLog(@"+++++++++++++++");
    for (NSInteger i = 0; i<10; i++) {
        NSData *data = [self.cache objectForKey:@(i)];
        if (data) {
            NSLog(@"取出数据%zd",i);
        }
    }
}

//删除数据
- (IBAction)removeBtnClick:(id)sender
{
    [self.cache removeAllObjects];
}

#pragma mark ----------------------
#pragma mark NSCacheDelegate
//即将回收对象的时候调用该方法
-(void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    NSLog(@"回收%zd",[obj length]);
}
@end
