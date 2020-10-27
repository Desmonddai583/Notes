//
//  XMGPopMenu.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//


#import "XMGPopMenu.h"
#import "XMGCover.h"

@implementation XMGPopMenu

// 当点击x号按钮的时候调用
- (IBAction)close:(id)sender {
    // 点击x号按钮,popMenu 慢慢缩小,边平移,
    // 缩小到一定尺寸,移除蒙版
    
    // 通知外界,点击了x号按钮
    if ([self.delegate respondsToSelector:@selector(popMenuDidCloseBtn:)]) {
        [self.delegate popMenuDidCloseBtn:self];
    }
}
+ (instancetype)showInCenter:(CGPoint)center{
    UIView *popMenu = [[NSBundle mainBundle] loadNibNamed:@"XMGPopMenu" owner:nil options:nil][0];
    popMenu.center = center;
    
    // 超出父控件剪切
//    popMenu.layer.masksToBounds = YES;
//    popMenu.clipsToBounds = YES;
    
    [XMGKeyWindow addSubview:popMenu];
    return popMenu;
}

- (void)hideInCenter:(CGPoint)center completion:(MyBlock)completion{
//    void(^completion1)() =^(){
//        // 2.移除蒙版
//        // 当动画执行完毕的时候移除蒙版
//        [XMGCover hide];
//    };
    
    // 子控件可以超出父控件
    [UIView animateWithDuration:0.5 animations:^{
        //        self.frame = CGRectMake(0, 0, 0, 0);
        self.center = center;
        
        // 比例 1.0 正常比例
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
//        self.frame = CGRectMake(0, 0, 50, 50);
//        
//        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        // 1.移除自己
        [self removeFromSuperview];
    
        
        // 2.移除蒙版
//        [XMGCover hide];
        // 1.用代理通知外界
        // 通知外界,点击了x号按钮
//        if ([self.delegate respondsToSelector:@selector(popMenuDidCloseBtn:)]) {
//            [self.delegate popMenuDidCloseBtn:self];
//        }
        // block当做参数传递, 如果值为空,直接调用崩溃
        if (completion) {
//            移除蒙版
            completion();
        }
        
    }];
}
@end
