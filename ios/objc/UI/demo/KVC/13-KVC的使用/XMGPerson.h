//
//  XMGPerson.h
//  13-KVC的使用
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMGDog;

@interface XMGPerson : NSObject


/** 姓名 */
@property (nonatomic, copy) NSString *name;
/** 钱 */
@property (nonatomic, assign) float money;
/** 狗 */
@property (nonatomic, strong) XMGDog *dog;

/** 序号 */
@property (nonatomic, copy) NSString *no;


- (void)printAge;

- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)personWithDict: (NSDictionary *)dict;

@end
