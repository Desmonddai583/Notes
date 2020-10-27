//
//  Person.m
//  02-UIApplication单例(了解)
//
//  Created by xiaomage on 16/1/14.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "Person.h"

@implementation Person

//1.程序一运行，就创建对象

static Person *_instance;
//什么时候调用：当类被加载到内存当中就会调用。
+(void)load{
    NSLog(@"%s",__func__);
    _instance = [[Person alloc] init];
}
//2.创建的对象，只有一个
+ (instancetype)sharedPerson{
    return _instance;
}
//3.只要调用alloc，程序就崩溃
//Terminating app due to uncaught exception 'NSInternalInconsistencyException',
//reason: 'There can only be one UIApplication instance.'


+(instancetype)alloc{
    if (_instance) {
        //程序就崩溃
        NSException *exc = [NSException exceptionWithName:@"NSInternalInconsistencyException"
                                                   reason:@"There can only be one Person instance."
                                                 userInfo:nil];
        
       
        //抛出异常
        [exc raise];
    }
    
    return [super alloc];
}


@end
