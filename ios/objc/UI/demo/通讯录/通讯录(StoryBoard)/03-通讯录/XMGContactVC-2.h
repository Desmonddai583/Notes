//
//  XMGContactVC-2.h
//  03-通讯录
//
//  Created by xiaomage on 16/1/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMGContactItem;
@interface XMGContactVC_2 : UITableViewController


//当前的用户名
@property (nonatomic, strong) NSString *accountName;


@property (nonatomic, strong) XMGContactItem *contactItem;


@end
