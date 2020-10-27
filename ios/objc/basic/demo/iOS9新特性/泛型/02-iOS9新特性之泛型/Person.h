//
//  Person.h
//  02-iOS9新特性之泛型
//
//  Created by xiaomage on 16/3/4.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person<ObjectType> : NSObject

// 语言
@property (nonatomic, strong) ObjectType language;

@end
