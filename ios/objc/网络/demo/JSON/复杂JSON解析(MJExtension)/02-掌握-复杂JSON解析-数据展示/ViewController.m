//
//  ViewController.m
//  02-掌握-复杂JSON解析-数据展示
//
//  Created by xiaomage on 16/2/25.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
#import "XMGVideo.h"
#import "MJExtension.h"

//baseUrlStr = @"http://120.25.226.186:32812"
#define baseUrlStr @"http://120.25.226.186:32812"
@interface ViewController ()
/** 注释 */
@property (nonatomic, strong) NSMutableArray *videos;
@end

@implementation ViewController

-(NSMutableArray *)videos
{
    if (_videos == nil) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    //替换
    [XMGVideo mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"ID":@"id"
                 };
    }];
    
    
    //1.url
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/video?type=JSON"];
    //2.创建请求对象
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    //3.发送异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       
        
        if (connectionError) {
            return ;
        }
        //4.解析数据
        NSDictionary *dictM = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:0];

        //字典转模型
        self.videos = [XMGVideo mj_objectArrayWithKeyValuesArray:dictM[@"videos"]];
        
        //5.更新UI
        [self.tableView reloadData];
    }];
}

#pragma mark ----------------------
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建cell
    static NSString *ID = @"video";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //2.设置cell
    //2.1 拿到该cell对应的数据
    //NSDictionary *dictM = self.videos[indexPath.row];
    XMGVideo *videoM = self.videos[indexPath.row];
    
    //2.2 设置标题
    cell.textLabel.text = videoM.name;
    
    //2.3 设置子标题
    cell.detailTextLabel.text = [NSString stringWithFormat:@"播放时间:%@",videoM.length];
    
    //NSString *baseUrlStr = @"http://120.25.226.186:32812";
    
    NSString *urlStr = [baseUrlStr stringByAppendingPathComponent:videoM.image];
    NSLog(@"%@",urlStr);
    
    //2.4 设置图片
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"Snip20160225_341"]];
    
    //ID----id
    NSLog(@"-----%@",videoM.ID);
    
    //3.返回cell
    return cell;
}

#pragma mark ----------------------
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.拿到数据
    //NSDictionary *dict = self.videos[indexPath.row];
      XMGVideo *videoM = self.videos[indexPath.row];
    
    //2.拼接数据
    NSString *urlStr = [baseUrlStr stringByAppendingPathComponent:videoM.url];
    
    //3.创建播放控制器
    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:urlStr]];
    
    //4.弹出控制器
    [self presentViewController:vc animated:YES completion:nil];
}

@end
