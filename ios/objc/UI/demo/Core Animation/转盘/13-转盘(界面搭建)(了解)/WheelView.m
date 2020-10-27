//
//  WheelView.m
//  13-转盘(界面搭建)(了解)
//
//  Created by xiaomage on 16/1/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "WheelView.h"
#import "WheelBtn.h"
#define angle2Rad(angle) ((angle) / 180.0 * M_PI)

@interface WheelView()

@property (weak, nonatomic) IBOutlet UIImageView *contentV;


/** <#注释#> */
@property (nonatomic, strong) CADisplayLink *link;

//当前选中的按钮
/** <#注释#> */
@property (nonatomic, weak) UIButton *selectBtn;


@end


@implementation WheelView



-(CADisplayLink *)link  {
    if (_link == nil) {
        
        //添加定时器,保持一直旋转
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _link = link;
        
    }
    return _link;
}

+ (instancetype)wheelView {
    
  return  [[[NSBundle mainBundle] loadNibNamed:@"WheelView" owner:nil options:nil] lastObject];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WheelView" owner:nil options:nil] lastObject];
    }
    return self;
}

-(void)awakeFromNib {
    
    
    
    self.contentV.userInteractionEnabled = YES;
    //添加转盘的按钮
    CGFloat btnW = 68;
    CGFloat btnH = 143;
    CGFloat angle = 0;
    
    //加载原始大图片
    UIImage *oriImage = [UIImage imageNamed:@"LuckyAstrology"];
    //加载原始选中的大图片
    UIImage *oriSelImage = [UIImage imageNamed:@"LuckyAstrologyPressed"];
    
    NSLog(@"%@",NSStringFromCGSize(oriImage.size));
    
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat clipW = oriImage.size.width / 12.0 * 2;
    CGFloat clipH = oriImage.size.height * 2;
    
    
    for(int i = 0; i < 12; i++) {
        WheelBtn *btn = [WheelBtn buttonWithType:UIButtonTypeCustom];
        btn.bounds = CGRectMake(0, 0, btnW, btnH);
        //[btn setBackgroundColor:[UIColor redColor]];
        
        //设置按钮选中状态下的背景图片
        [btn setBackgroundImage:[UIImage imageNamed:@"LuckyRototeSelected"] forState:UIControlStateSelected];
        
        
        //给定一张图片,截取指定区域范围内的图片,
        X = i * clipW;
        
        //CGImageCreateWithImageInRect,使用的坐标都是以像素点,
        //在ios当中使用的都是点坐标.
       CGImageRef clipImage =  CGImageCreateWithImageInRect(oriImage.CGImage, CGRectMake(X, Y, clipW, clipH));
        //设置按钮正常状态下显示的图片
        [btn setImage:[UIImage imageWithCGImage:clipImage] forState:UIControlStateNormal];
        
        CGImageRef clipSelImage =  CGImageCreateWithImageInRect(oriSelImage.CGImage, CGRectMake(X, Y, clipW, clipH));
        //设置按钮选中状态下显示的图片
        [btn setImage:[UIImage imageWithCGImage:clipSelImage] forState:UIControlStateSelected];
        
        
        
        //设置按钮位置
        btn.layer.anchorPoint = CGPointMake(0.5, 1);
        btn.layer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);

        
        //让第一个按钮在上一个基础上面旋转30.
        btn.transform = CGAffineTransformMakeRotation(angle2Rad(angle));
        angle += 30;
        
        //监听按钮的点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentV addSubview:btn];
        
        //默认让第一个成为选中状态
        if (i == 0) {
            [self btnClick:btn];
        }

        
    }
}


- (void)btnClick:(UIButton *)btn {
    
    //让当前点击的按钮成为选中状态
    
    //1.让当前选中的按钮取消选中.
    self.selectBtn.selected = NO;
    //2.让当前点击的按钮成为选中状态
    btn.selected = YES;
    //3.当前点击的按钮成为选中状态
    self.selectBtn = btn;
    
}


//让转盘开始旋转
- (void)rotation {

    self.link.paused = NO;
    
//    CABasicAnimation *anim = [CABasicAnimation animation];
//    anim.keyPath = @"transform.rotation";
//    anim.toValue = @(M_PI * 3);
//    anim.duration = 5;
//    anim.repeatCount = MAXFLOAT;
//    
//    [self.contentV.layer addAnimation:anim forKey:nil];
    
}


//让转盘暂停旋转
- (void)stop {
    self.link.paused = YES;
}


- (void)update {
    
    self.contentV.transform = CGAffineTransformRotate(self.contentV.transform, M_PI / 300.0);
}

//开始选号
- (IBAction)startChoose:(id)sender {
    
    //让转盘快速的旋转几圈,
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.toValue = @(M_PI * 4);
    anim.duration = 0.5;
    anim.delegate = self;
    [self.contentV.layer addAnimation:anim forKey:nil];
    
    //动画结束时当前选中的按钮指向最上方

}

//当动画结束时调用
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    //动画结束时当前选中的按钮指向最上方
    //让当前选中的按钮的父控件倒着旋转回去.
    
    //获取当前选中按钮旋转的角度
    CGAffineTransform transform = self.selectBtn.transform;
    //通过transform获取当前旋转的度数
    CGFloat angle = atan2(transform.b, transform.a);
    
    NSLog(@"%f",angle);
    
    
    self.contentV.transform = CGAffineTransformMakeRotation(-angle);
    
}



@end
