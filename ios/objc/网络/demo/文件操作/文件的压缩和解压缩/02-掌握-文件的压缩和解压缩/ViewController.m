//
//  ViewController.m
//  02-掌握-文件的压缩和解压缩
//
//  Created by xiaomage on 16/2/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "SSZipArchive.h"

@interface ViewController ()

@end

@implementation ViewController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self unzip];
}

-(void)zip
{
    NSArray *arrayM = @[
                        @"/Users/xiaomage/Desktop/Snip20160226_2.png",
                        @"/Users/xiaomage/Desktop/Snip20160226_6.png"
                        ];
    /*
     第一个参数:压缩文件的存放位置
     第二个参数:要压缩哪些文件(路径)
     */
    //[SSZipArchive createZipFileAtPath:@"/Users/xiaomage/Desktop/Test.zip" withFilesAtPaths:arrayM];
    [SSZipArchive createZipFileAtPath:@"/Users/xiaomage/Desktop/Test.zip" withFilesAtPaths:arrayM withPassword:@"123456"];
}

-(void)zip2
{
    /*
     第一个参数:压缩文件存放位置
     第二个参数:要压缩的文件夹(目录)
     */
    [SSZipArchive createZipFileAtPath:@"/Users/xiaomage/Desktop/demo.zip" withContentsOfDirectory:@"/Users/xiaomage/Desktop/demo"];
}

-(void)unzip
{
    /*
     第一个参数:要解压的文件在哪里
     第二个参数:文件应该解压到什么地方
     */
    //[SSZipArchive unzipFileAtPath:@"/Users/xiaomage/Desktop/demo.zip" toDestination:@"/Users/xiaomage/Desktop/xx"];
    
    [SSZipArchive unzipFileAtPath:@"/Users/xiaomage/Desktop/demo.zip" toDestination:@"/Users/xiaomage/Desktop/xx" progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
        NSLog(@"%zd---%zd",entryNumber,total);
        
    } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
        
        NSLog(@"%@",path);
    }];
}


@end
