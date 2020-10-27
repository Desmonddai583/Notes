//
//  XMGContactItem.h
//  03-通讯录
//
//  Created by xiaomage on 16/1/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGContactItem : NSObject

/** 姓名 */
@property (nonatomic, strong) NSString *name;

/** 电话 */
@property (nonatomic, strong) NSString *phone;


+ (instancetype)itemWithName:(NSString *)name phone:(NSString *)phone;



@end
