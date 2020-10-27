//
//  GlobeConst.h
//  06-extern和const联合使用
//
//  Created by xiaomage on 16/3/5.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
// YYKIT

// XMGKIT
#ifdef __cplusplus
#define XMGKIT_EXTERN		extern "C" __attribute__((visibility ("default")))
#else
#define XMGKIT_EXTERN	        extern __attribute__((visibility ("default")))
#endif

XMGKIT_EXTERN NSString * const discover_name;

