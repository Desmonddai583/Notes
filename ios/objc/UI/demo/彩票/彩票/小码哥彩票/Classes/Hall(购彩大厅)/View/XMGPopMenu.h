//
//  XMGPopMenu.h
//  小码哥彩票
//
//  Created by xiaomage on 16/1/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//
// MyBlock 的类型 void(^)()
typedef void(^MyBlock)();

#import <UIKit/UIKit.h>
@class XMGPopMenu;

@protocol XMGPopMenuDelegate <NSObject>

- (void)popMenuDidCloseBtn:(XMGPopMenu *)popMenu;
//- (void)popMenuDidCloseBtn:(XMGPopMenu *)popMenu;
@end

@interface XMGPopMenu : UIView

+ (instancetype)showInCenter:(CGPoint)center;

//- (void)hideInCenter:(CGPoint)center ;

//- (void)hideInCenter:(CGPoint)center completion:(参数类型)参数名;

// 没有参数没有返回值block void(^)()

- (void)hideInCenter:(CGPoint)center completion:(MyBlock)completion;

@property (nonatomic, weak) id<XMGPopMenuDelegate> delegate;
@end
