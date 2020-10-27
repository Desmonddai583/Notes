//
//  XMGPopMenu.h
//  小码哥彩票
//
//  Created by simplyou on 15/11/11.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGPopMenu;

@protocol XMGPopMenuDelegate <NSObject>

- (void)popMenudDidColseBtn:(XMGPopMenu *)popMenu;

@end

@interface XMGPopMenu : UIView
// 创建菜单显示在什么位置
+ (instancetype)showInCenter:(CGPoint)center;


// 隐藏菜单,到什么位置

// block 参数类型 void(^)()
//- (void)hiddenInCenter:(CGPoint)center completion:(类型)参数;

- (void)hiddenInCenter:(CGPoint)center completion:(void(^)())completion;


@property (nonatomic, weak) id<XMGPopMenuDelegate> delegae;
@end
