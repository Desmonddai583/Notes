//
//  XMGStatusFrame.h
//  备课07-自定义不等高的cell-frame
//
//  Created by FTD_ZHC on 15/9/23.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

// MVVM
@class XMGStatus;
@interface XMGStatusFrame : NSObject

/**
 *  模型数据
 */
@property (nonatomic ,strong)XMGStatus * status;


/**
 *  头像的frame
 */
@property (nonatomic ,assign)CGRect iconFrame;
/**
 *  昵称的frame
 */
@property (nonatomic ,assign)CGRect nameFrame;
/**
 *  vip的frame
 */
@property (nonatomic ,assign)CGRect vipFrame;
/**
 *  内容的frame
 */
@property (nonatomic ,assign)CGRect textFrame;
/**
 *  配图的frame
 */
@property (nonatomic ,assign)CGRect pictureFrame;



/**
 *  cell的高度
 */
@property (nonatomic ,assign)CGFloat cellHeight;

@end
