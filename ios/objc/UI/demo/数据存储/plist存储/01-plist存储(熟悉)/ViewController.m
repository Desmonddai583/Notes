//
//  ViewController.m
//  01-plist存储(熟悉)
//
//  Created by xiaomage on 16/1/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)save:(id)sender {
    
 
   
    //第一个参数:搜索的目录
    //第二个参数:搜索的范围
    //第三个参数:是否展开路径(在ios当中识别~)
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//    NSLog(@"%@",path);
    
    //拼接一个文件名
    //NSString *filePath = [path stringByAppendingString:@"data.plist"];
    ///Users/xiaomage/Library/Developer/CoreSimulator/Devices/5D7C40BE-CCF7-499D-87B3-E17D9A93798D/data/Containers/Data/Application/6BED8552-9E13-4300-9154-3741F2CF92C4/Documentsdata.plist
    //stringByAppendingPathComponent拼接一个文件路径.自动加一个(/)
    //NSString *filePath = [path stringByAppendingPathComponent:@"data.plist"];
    //NSLog(@"%@",filePath);
    
    //把数组保存到沙盒
    //NSArray *dataArray =  @[@"xmg",@10];
    //路径是沙盒路径.
    //[dataArray writeToFile:filePath atomically:YES];
    
    
    Person *per = [[Person alloc] init];
    per.name = @"xmg";
    per.age = 10;
    
    //在plist文件当中是不能够保存自定义的对象
    NSDictionary *dict = @{@"name" : @"xmg",@"age" : @10};
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *dictPath = [path stringByAppendingPathComponent:@"dict.plist"];
    [dict writeToFile:dictPath atomically:YES];
    
}

- (IBAction)read:(id)sender {
    
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString *filePath = [path stringByAppendingPathComponent:@"data.plist"];
//    NSArray *dataArray = [NSArray arrayWithContentsOfFile:filePath];
//    NSLog(@"%@",dataArray);
//    
    
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"dict.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSLog(@"%@",dict);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
