//
//  ModalViewController.h
//  03-block开发使用场景（传值）
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class ModalViewController;
//@protocol ModalViewControllerDelegate <NSObject>
//
//@optional
//// 设计方法:想要代理做什么事情
//- (void)modalViewController:(ModalViewController *)modalVc sendValue:(NSString *)value;
//
//@end

@interface ModalViewController : UIViewController


@property (nonatomic, strong) void(^block)(NSString *value);
//@property (nonatomic, weak) id<ModalViewControllerDelegate> delegate;

@end
