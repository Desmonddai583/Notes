//
//  XMGPopMenu.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/11.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGPopMenu.h"
//#import "XMGCover.h"
//#import "UIView+XMG.h"

@implementation XMGPopMenu
/**
 *  点击关闭按钮
 */
- (IBAction)colseBtn:(id)sender {
    // 通知代理
    if ([self.delegae respondsToSelector:@selector(popMenudDidColseBtn:)]){
        [self.delegae popMenudDidColseBtn:self];
    }
    
}
- (void)hiddenInCenter:(CGPoint)center completion:(void (^)())completion{
    /*
     // 封装菜单动画执行完毕的时候调用的代码
     void (^completion)() = ^{
     // 当菜单的动画执行完毕的时候,隐藏蒙版
     [XMGCover hidden];
     };
     */
    
    [UIView animateWithDuration:0.25f animations:^{
        // 子控件不随父控件的缩小而缩小
        
        //        self.frame = CGRectMake(44, 44, 0, 0);
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.center = center;
        
//        CGRect frame = self.frame;
//        frame.size.width = 100;
//        self.frame = frame;
        
//        self.width = 100;
//        
//        self.width = 100;
//        self.x = 0;
//        self.y = 100;
//        self.height = 200;
        
//        NSLog(@"%f",self.width);
        
        
        // 子控件随着父控件缩小而缩小
        // 超出父控件剪切
        //        self.layer.masksToBounds = YES;
        //        self.clipsToBounds = YES;
        
    } completion:^(BOOL finished) {
        // 移除菜单
        [self removeFromSuperview];
      
        // 在开发中不建议
        
        // 当你玩成不了得时候可以这样实现, 先实现功能在封装
//        [XMGCover hidden];
        
        // 判断有没有值如果没有值不能调用, 如果调用程序会挂掉
        if (completion) {
            completion();
        }
//        [XMGCover hidden];
    }];
}
+ (instancetype)showInCenter:(CGPoint)center{
    // 弹出菜单 添加到KeyWindow
    XMGPopMenu *view = [[NSBundle mainBundle] loadNibNamed:@"XMGPopMenu" owner:nil options:nil][0];
    view.center = center;
    [[UIApplication sharedApplication].keyWindow addSubview:view];

    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
