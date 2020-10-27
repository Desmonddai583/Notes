//
//  ViewController.m
//  10-手势识别(拖动, 旋转,缩放)(熟悉)
//
//  Created by xiaomage on 16/1/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.imageV.userInteractionEnabled = YES;
    
     //添加旋转手势
    [self rotationGes];
    
      //添加捏合手势
    [self pinch];

    
    
}

//Simultaneous:同时
//是否允许同时支持多个手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    return YES;
}


 //添加旋转手势
- (void)rotationGes{
    //添加旋转手势
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGes:)];
    
    rotation.delegate = self;
    
    [self.imageV addGestureRecognizer:rotation];
}



- (void)rotationGes:(UIRotationGestureRecognizer *)rotationGes{

    self.imageV.transform = CGAffineTransformRotate(self.imageV.transform, rotationGes.rotation);
    
    //复位
    [rotationGes setRotation:0];
    
    
}

  //添加捏合手势
- (void)pinch{
  
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    pinch.delegate = self;
    [self.imageV addGestureRecognizer:pinch];
}

//当缩放时调用
- (void)pinch:(UIPinchGestureRecognizer *)pinch{
    NSLog(@"%s",__func__);
    self.imageV.transform = CGAffineTransformScale(self.imageV.transform, pinch.scale,pinch.scale );
    
    //复位
    [pinch setScale:1];
}



- (void)panGes{
    //添加拖动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.imageV addGestureRecognizer:pan];
}

//当拖动View时调用
- (void)pan:(UIPanGestureRecognizer *)pan {
    
    //获取偏移量(相对于最原始的偏移量)
    CGPoint transP = [pan translationInView:self.imageV];
    NSLog(@"%@",NSStringFromCGPoint(transP));
    
    self.imageV.transform = CGAffineTransformTranslate(self.imageV.transform, transP.x, transP.y);
    
    //让它相对于上一次
    //复位.
    [pan setTranslation:CGPointZero inView:self.imageV];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
