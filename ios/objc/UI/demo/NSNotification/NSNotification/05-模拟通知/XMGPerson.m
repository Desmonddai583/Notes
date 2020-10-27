//
//  XMGPerson.m
//  05-模拟通知
//
//  Created by xiaomage on 16/1/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGPerson.h"

@implementation XMGPerson

- (void)getNew:(NSNotification *)note
{
    NSLog(@"[%@]接收到了[%@]发布的[%@]通知,通知的内容是:[%@]",self.name,[note.object name],note.name,note.userInfo);
}
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
@end
