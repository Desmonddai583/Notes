//
//  XMGAPP.h
//  12-掌握-多图下载综合案例-数据展示
//
//  Created by xiaomage on 16/2/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGAPP : NSObject

/** APP的名称 */
@property (nonatomic, strong) NSString *name;
/** APP的图片的url地址 */
@property (nonatomic, strong) NSString *icon;
/** APP的下载量 */
@property (nonatomic, strong) NSString *download;

+(instancetype)appWithDict:(NSDictionary *)dict;
@end
