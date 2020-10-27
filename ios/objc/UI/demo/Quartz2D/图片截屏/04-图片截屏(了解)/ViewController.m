//
//  ViewController.m
//  04-图片截屏(了解)
//
//  Created by xiaomage on 16/1/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

//开始时手指的点
/** <#注释#> */
@property (nonatomic, assign) CGPoint startP;

/** <#注释#> */
@property (nonatomic, weak) UIView *coverV;

@end

@implementation ViewController

/**
 *  懒加载coverV
 *  1.能够保证超始至终只有一份
 *  2.什么时候用到什么时候才去加载
 */
-(UIView *)coverV {
    
    if (_coverV == nil) {
        
        //添加一个UIView
        UIView *coverV = [[UIView alloc] init];
        coverV.backgroundColor = [UIColor blackColor];
        coverV.alpha = 0.7;
        _coverV = coverV;
        [self.view addSubview:coverV];
    }
    return _coverV;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageV.userInteractionEnabled = YES;
}
- (IBAction)pan:(UIPanGestureRecognizer *)pan {
    
    //判断手势的状态
    CGPoint curP = [pan locationInView:self.imageV];
    if(pan.state == UIGestureRecognizerStateBegan) {
        self.startP = curP;
    } else if(pan.state == UIGestureRecognizerStateChanged) {
        
        CGFloat x = self.startP.x;
        CGFloat y = self.startP.y;
        CGFloat w = curP.x - self.startP.x;
        CGFloat h = curP.y - self.startP.y;
        CGRect rect =  CGRectMake(x, y, w, h);
        
        //添加一个UIView
        self.coverV.frame = rect;
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        
      
        //把超过coverV的frame以外的内容裁剪掉
        //生成了一张图片,把原来的图片给替换掉.
        UIGraphicsBeginImageContextWithOptions(self.imageV.bounds.size, NO, 0);
        
        //把ImageV绘制到上下文之前,设置一个裁剪区域
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:self.coverV.frame];
        [clipPath addClip];
        
        
     
        //把当前的ImageView渲染到上下文当中
        CGContextRef ctx =  UIGraphicsGetCurrentContext();
        [self.imageV.layer renderInContext:ctx];
        //.从上下文当中生成 一张图片
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        
      
       
        
        self.imageV.image = newImage;
        

        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
