//
//  Person.h
//  04-iOS9新特性之__kindof
//
//  Created by xiaomage on 16/3/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

// xcode5 才出 instancetype

// Xcode5之前 id
// instancetype:自动识别当前类的对象
+ (__kindof Person *)person;

@end
