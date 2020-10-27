//
//  XMGAddContactVC-3.h
//  03-通讯录
//
//  Created by xiaomage on 16/1/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XMGAddContactVC_3,XMGContactItem;
//1.定义协议
@protocol XMGAddContactVCDelegate <NSObject>

//2.定义协议方法
- (void)addContactVC:(XMGAddContactVC_3 *)addContactVC contactItem:(XMGContactItem *)contactItem;

@end





@interface XMGAddContactVC_3 : UIViewController



/** <#注释#> */
@property (nonatomic, weak) id<XMGAddContactVCDelegate> delegate;




@end
