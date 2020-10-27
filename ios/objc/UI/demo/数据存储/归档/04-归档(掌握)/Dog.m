//
//  Dog.m
//  04-归档(掌握)
//
//  Created by xiaomage on 16/1/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "Dog.h"

@implementation Dog


-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.name forKey:@"name"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}



@end
