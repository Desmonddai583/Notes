//
//  XMGSettingSwitchItem.h
//  小码哥彩票
//
//  Created by simplyou on 15/11/14.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGSettingItem.h"

@interface XMGSettingSwitchItem : XMGSettingItem
/**
 *  状态
 */
@property (nonatomic, assign, getter=isOpen) BOOL open;
@end
