//
//  ViewController.m
//  04-掌握-ARC环境下实现单例模式
//
//  Created by xiaomage on 16/2/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGTool.h"
#import "XMGDownloadTool.h"
@interface ViewController ()

@end

@implementation ViewController

//单例不能使用继承
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"%@---%@",[[XMGDownloadTool alloc]init],[XMGDownloadTool shareDownloadTool]);
    
    XMGTool *t1 = [[XMGTool alloc]init];
    
    XMGTool *t2 = [[XMGTool alloc]init];
    
    XMGTool *t3 = [XMGTool new];
    XMGTool *t4 = [XMGTool shareTool];
    XMGTool *t5 = [t1 copy];
    XMGTool *t6 = [t1 mutableCopy];
    NSLog(@"t1:%@ t2:%@ t3:%p t4:%p t5:%p t6:%p",t1,t2,t3,t4,t5,t6);
}
@end
