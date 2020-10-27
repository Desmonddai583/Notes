//
//  Person.h
//  04-归档(掌握)
//
//  Created by xiaomage on 16/1/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Dog;
@interface Person : NSObject<NSCoding>

/** <#注释#> */
@property (nonatomic, strong) NSString *name;

/** <#注释#> */
@property (nonatomic, assign) int age;

/** <#注释#> */
@property (nonatomic, strong) Dog *dog;






@end
