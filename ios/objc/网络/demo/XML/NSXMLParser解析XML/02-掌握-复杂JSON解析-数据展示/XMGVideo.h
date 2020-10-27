//
//  XMGVideo.h
//  02-掌握-复杂JSON解析-数据展示
//
//  Created by xiaomage on 16/2/25.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGVideo : NSObject

/** ID */
@property (nonatomic, strong) NSString *ID;
/** 图片地址 */
@property (nonatomic, strong) NSString *image;
/** 播放时间 */
@property (nonatomic, strong) NSString *length;
/** 标题*/
@property (nonatomic, strong) NSString *name;
/** 视频的url */
@property (nonatomic, strong) NSString *url;
@end
