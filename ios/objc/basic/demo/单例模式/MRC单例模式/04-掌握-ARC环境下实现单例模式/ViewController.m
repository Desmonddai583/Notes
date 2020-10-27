//
//  ViewController.m
//  04-掌握-ARC环境下实现单例模式
//
//  Created by xiaomage on 16/2/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGTool.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    XMGTool *t1 = [[XMGTool alloc]init];
//    //[t1 release];
//    
//    XMGTool *t2 = [[XMGTool alloc]init];
//    //[t2 release];
//    //release -1
//    //retain +1
//    //message sent to deallocated instance 0x7fa102d16190
//    
//    XMGTool *t3 = [XMGTool new];
//    XMGTool *t4 = [XMGTool shareTool];
//    XMGTool *t5 = [t1 copy];
//    XMGTool *t6 = [t1 mutableCopy];
//  NSLog(@"t1:%p t2:%p t3:%p t4:%p t5:%p t6:%p",t1,t2,t3,t4,t5,t6);
    
#if __has_feature(objc_arc)
    //条件满足 ARC
    NSLog(@"ARC");
#else
    NSLog(@"MRC");
#endif
    
}
@end
