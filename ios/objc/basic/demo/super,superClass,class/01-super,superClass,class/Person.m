//
//  Person.m
//  01-super,superClass,class
//
//  Created by xiaomage on 16/3/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)test
{
    // self -> SubPerson
    // SubPerson Person  SubPerson Person
     NSLog(@"%@ %@ %@ %@",[self class], [self superclass], [super class], [super superclass]);
}
@end
