//
//  ViewController.m
//  06-时钟(了解)
//
//  Created by xiaomage on 16/1/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

//每一秒旋转的度数
#define perSecA 6

//每一分旋转的度数
#define perMinA 6

//每一小时旋转的度数
#define perHourA 30

//每一分,时针旋转的度数
#define perMinHour 0.5


#define angle2Rad(angle) ((angle) / 180.0 * M_PI)

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *colockView;

/** 当前的秒针 */
@property (nonatomic, weak)   CALayer *secL;
/** 当前的分针 */
@property (nonatomic, weak)   CALayer *minL;
/** 当前的针针 */
@property (nonatomic, weak)   CALayer *hourL;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //添加时针
    [self setHour];
    
    //添加分针
    [self setMin];
    //添加秒针
    [self setSec];
    
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
    [self timeChange];
}

//第一称调用一次
- (void)timeChange {
    
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    //components:日历的组件,年,月,日 ,时,分,秒.
    //fromDate:从什么时间开始获取
    NSDateComponents *cmp = [cal components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour  fromDate:[NSDate date]];
    //获取当前多少秒
    NSInteger curSec = cmp.second + 1;
    
    
    //秒针开始旋转
    //计算秒针当前旋转的角度.
    //angle  = 当前多少秒 * 每一秒旋转多少度.
    CGFloat secA = curSec * perSecA;
    self.secL.transform = CATransform3DMakeRotation(angle2Rad(secA), 0, 0, 1);
    
    
    //获取当前多少秒
    NSInteger curMin = cmp.minute;
    NSLog(@"%ld",curMin);
    //分针开始旋转
    //计算分针当前旋转的角度.
    //angle  = 当前多少分 * 每一分旋转多少度.
    CGFloat minA = curMin * perMinA;
    self.minL.transform = CATransform3DMakeRotation(angle2Rad(minA), 0, 0, 1);
    
    //获取当前是多少小时
    NSInteger curHour = cmp.hour;
    NSLog(@"%ld",curMin);
    //分针开始旋转
    //计算分针当前旋转的角度.
    //angle  = 当前多少小时 * 每一小时旋转多少度.
    CGFloat hourA = curHour * perHourA + curMin * perMinHour;
    self.hourL.transform = CATransform3DMakeRotation(angle2Rad(hourA), 0, 0, 1);
    
    
}


//添加秒针
//无论是旋转,缩放都是绕着锚点进行的.
- (void)setSec {
    
    CALayer *secL = [CALayer layer];
    secL.bounds = CGRectMake(0, 0, 1, 80);
    secL.backgroundColor = [UIColor redColor].CGColor;
    secL.anchorPoint = CGPointMake(0.5, 1);
    secL.position = CGPointMake(self.colockView.bounds.size.width * 0.5, self.colockView.bounds.size.height * 0.5);
    [self.colockView.layer addSublayer:secL];
    self.secL = secL;
    
}

//添加分针
- (void)setMin {
    
    CALayer *minL = [CALayer layer];
    minL.bounds = CGRectMake(0, 0, 3, 70);
    minL.backgroundColor = [UIColor blackColor].CGColor;
    minL.anchorPoint = CGPointMake(0.5, 1);
    minL.cornerRadius = 1.5;
    minL.position = CGPointMake(self.colockView.bounds.size.width * 0.5, self.colockView.bounds.size.height * 0.5);
    [self.colockView.layer addSublayer:minL];
    self.minL = minL;
    
}

//时针
- (void)setHour {
    
    CALayer *hourL = [CALayer layer];
    hourL.bounds = CGRectMake(0, 0, 3, 50);
    hourL.backgroundColor = [UIColor blackColor].CGColor;
    hourL.anchorPoint = CGPointMake(0.5, 1);
    hourL.cornerRadius = 1.5;
    hourL.position = CGPointMake(self.colockView.bounds.size.width * 0.5, self.colockView.bounds.size.height * 0.5);
    [self.colockView.layer addSublayer:hourL];
    self.hourL = hourL;
    
}




//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    //所有旋转,缩放,都是绕着锚点进行.
//    self.secL.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
//}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
