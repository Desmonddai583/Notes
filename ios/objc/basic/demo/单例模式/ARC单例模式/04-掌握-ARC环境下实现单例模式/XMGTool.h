//
//  XMGTool.h
//  04-掌握-ARC环境下实现单例模式
//
//  Created by xiaomage on 16/2/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGTool : NSObject<NSCopying, NSMutableCopying>

//类方法
//1.方便访问
//2.标明身份
//3.注意:share+类名|default + 类名 | share | default | 类名
+(instancetype)shareTool;
@end
