//
//  XMGAddContactVC.h
//  通讯录(纯代码)
//
//  Created by xiaomage on 16/1/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMGAddContactVC,XMGContactItem;
//1.定义协议
@protocol XMGAddContactVCDelegate <NSObject>

//2.定义协议方法
- (void)addContactVC:(XMGAddContactVC *)addContactVC contactItem:(XMGContactItem *)contactItem;

@end




@interface XMGAddContactVC : UIViewController

@property (nonatomic, weak) id<XMGAddContactVCDelegate> delegate;





@end
