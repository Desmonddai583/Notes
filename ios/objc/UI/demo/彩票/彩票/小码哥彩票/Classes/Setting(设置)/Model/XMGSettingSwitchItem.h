//
//  XMGSettingSwitchItem.h
//  小码哥彩票
//
//  Created by xiaomage on 16/2/2.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGSettingItem.h"

@interface XMGSettingSwitchItem : XMGSettingItem
/** 开关状态 */
@property (nonatomic, assign, getter=isOn) BOOL on;
@end
