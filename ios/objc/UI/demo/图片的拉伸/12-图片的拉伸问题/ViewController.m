//
//  ViewController.m
//  12-图片的拉伸问题
//
//  Created by xiaomage on 15/12/30.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+XMGExtention.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.1 创建UIImage对象
//    UIImage *image = [UIImage resizableImageWithLocalImageName:@"chat_send_nor"];
    
    UIImage *image = [UIImage imageNamed:@"chat_send_nor"];
    
    // 1.2 拿到image的尺寸
    /*
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    */
    
    // 1.3 返回一张受保护而且拉伸的图片 --->CapInsets:哪些地方要保护
    
    // 方式一
    /*
    UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageHeight * 0.5, imageWidth * 0.5, imageHeight * 0.5 -1, imageWidth * 0.5 - 1)];

     UIImageResizingModeTile, 平铺
     UIImageResizingModeStretch, 拉伸(伸缩)
    UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageHeight * 0.5, imageWidth * 0.5, imageHeight * 0.5 -1, imageWidth * 0.5 - 1) resizingMode:UIImageResizingModeTile];
    */
    
    // 方式二
    /*
     // 右边需要保护的区域 = 图片的width - leftCapWidth - 1
     // bottom cap =  height - topCapHeight - 1
//    UIImage *resizableImage = [image stretchableImageWithLeftCapWidth:imageWidth * 0.5 topCapHeight:imageHeight * 0.5];
     */
    
    //2.把图片设置到按钮上
    [self.button setBackgroundImage:image forState:UIControlStateNormal];
     
}

@end
