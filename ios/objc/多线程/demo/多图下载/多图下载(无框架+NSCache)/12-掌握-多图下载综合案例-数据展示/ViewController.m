//
//  ViewController.m
//  12-掌握-多图下载综合案例-数据展示
//
//  Created by xiaomage on 16/2/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGAPP.h"

@interface ViewController ()
/** tableView的数据源 */
@property (nonatomic, strong) NSArray *apps;
/** 内存缓存 */
@property (nonatomic, strong) NSCache *images;
/** 队列 */
@property (nonatomic, strong) NSOperationQueue *queue;
/** 操作缓存 */
@property (nonatomic, strong) NSMutableDictionary *operations;
@end

@implementation ViewController

#pragma mark ----------------------
#pragma mark lazy loading
-(NSOperationQueue *)queue
{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc]init];
        //设置最大并发数
        _queue.maxConcurrentOperationCount = 5;
    }
    return _queue;
}
-(NSCache *)images
{
    if (_images == nil) {
        _images = [[NSCache alloc]init];

        //设置最多可以缓存多少个数据
        //_images.countLimit = 4;
    }
    return _images;
}
-(NSArray *)apps
{
    if (_apps == nil) {
        
        //字典数组
        NSArray *arrayM = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"apps.plist" ofType:nil]];
        
        //字典数组---->模型数组
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dict in arrayM) {
            [arrM addObject:[XMGAPP appWithDict:dict]];
        }
        _apps = arrM;
    }
    return _apps;
}

-(NSMutableDictionary *)operations
{
    if (_operations == nil) {
        _operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

#pragma mark ----------------------
#pragma mark UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.apps.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"app";
    
    //1.创建cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //2.设置cell的数据
    //2.1 拿到该行cell对应的数据
    XMGAPP *appM = self.apps[indexPath.row];
    
    //2.2 设置标题
    cell.textLabel.text = appM.name;
    
    //2.3 设置子标题
    cell.detailTextLabel.text = appM.download;
    
    //2.4 设置图标
    
    //先去查看内存缓存中该图片时候已经存在,如果存在那么久直接拿来用,否则去检查磁盘缓存
    //如果有磁盘缓存,那么保存一份到内存,设置图片,否则就直接下载
    //1)没有下载过
    //2)重新打开程序
    
    UIImage *image = [self.images objectForKey:appM.icon];
    if (image) {
        cell.imageView.image = image;
        NSLog(@"%zd处的图片使用了内存缓存中的图片",indexPath.row) ;
    }else
    {
        //保存图片到沙盒缓存
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //获得图片的名称,不能包含/
        NSString *fileName = [appM.icon lastPathComponent];
        //拼接图片的全路径
        NSString *fullPath = [caches stringByAppendingPathComponent:fileName];
        
        
        //检查磁盘缓存
        NSData *imageData = [NSData dataWithContentsOfFile:fullPath];
        //废除
        imageData = nil;
        
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.imageView.image = image;
            
            NSLog(@"%zd处的图片使用了磁盘缓存中的图片",indexPath.row) ;
            //把图片保存到内存缓存
            [self.images setObject:image forKey:appM.icon];
            
//            NSLog(@"%@",fullPath);
        }else
        {
            //检查该图片时候正在下载,如果是那么久什么都捕捉,否则再添加下载任务
            NSBlockOperation *download = [self.operations objectForKey:appM.icon];
            if (download) {
                
            }else
            {
                
                //先清空cell原来的图片
                cell.imageView.image = [UIImage imageNamed:@"Snip20160221_306"];
                
                download = [NSBlockOperation blockOperationWithBlock:^{
                    NSURL *url = [NSURL URLWithString:appM.icon];
                    NSData *imageData = [NSData dataWithContentsOfURL:url];
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                     NSLog(@"%zd--下载---",indexPath.row);
                    
                    //容错处理
                    if (image == nil) {
                        [self.operations removeObjectForKey:appM.icon];
                        return ;
                    }
                    //演示网速慢的情况
                    //[NSThread sleepForTimeInterval:3.0];
                    
                    //把图片保存到内存缓存
                    [self.images setObject:image forKey:appM.icon];
                    
                    //NSLog(@"Download---%@",[NSThread currentThread]);
                    //线程间通信
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        //cell.imageView.image = image;
                        //刷新一行
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        //NSLog(@"UI---%@",[NSThread currentThread]);
                    }];
                    
                    
                    //写数据到沙盒
                    [imageData writeToFile:fullPath atomically:YES];
                   
                    //移除图片的下载操作
                    [self.operations removeObjectForKey:appM.icon];
                    
                }];
                
                //添加操作到操作缓存中
                [self.operations setObject:download forKey:appM.icon];
                
                //添加操作到队列中
                [self.queue addOperation:download];
            }
            
        }
    }
    
    //3.返回cell
    return cell;
}

#pragma mark ----------------------
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *arrayM = self.apps;
    //检查缓存数据
    for (NSInteger i = 0; i < arrayM.count; i++) {
        XMGAPP *appM = arrayM[i];
        
        UIImage *image = [self.images objectForKey:appM.icon];
        if (image) {
            NSLog(@"存在图片缓存%zd",i);
        }
    }
}

-(void)didReceiveMemoryWarning
{
    [self.images removeAllObjects];
    
    //取消队列中所有的操作
    [self.queue cancelAllOperations];
}

//1.UI很不流畅 --- > 开子线程下载图片
//2.图片重复下载 ---> 先把之前已经下载的图片保存起来(字典)
//内存缓存--->磁盘缓存

//3.图片不会刷新--->刷新某行
//4.图片重复下载(图片下载需要时间,当图片还未完全下载之前,又要重新显示该图片)
//5.数据错乱 ---设置占位图片

/*
 Documents:会备份,不允许
 Libray
    Preferences:偏好设置 保存账号
    caches:缓存文件
 tmp:临时路径(随时会被删除)
 */

@end
