//
//  ViewController.m
//  04-position和anchorPoint(掌握)
//
//  Created by xiaomage on 16/1/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *orangeView;

/** <#注释#> */
@property (nonatomic, weak) CALayer *layer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    CALayer *layer = [CALayer layer];
//    layer.frame = CGRectMake(200, 200, 100, 100);
//    layer.backgroundColor = [UIColor redColor].CGColor;
//    
//    self.layer = layer;
//    [self.view.layer addSublayer:layer];
    
    //UIView的center,就是它内部layer的position.
    NSLog(@"center = %@",NSStringFromCGPoint(self.orangeView.center));
    NSLog(@"position = %@",NSStringFromCGPoint(self.orangeView.layer.position));
    
 
    
    
  
    
    
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  // self.layer.position = CGPointMake(200, 200);
   
    NSLog(@"center = %@",NSStringFromCGPoint(self.orangeView.center));
    NSLog(@"position = %@",NSStringFromCGPoint(self.orangeView.layer.position));
    
    self.orangeView.layer.anchorPoint = CGPointMake(0.5, 0);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
