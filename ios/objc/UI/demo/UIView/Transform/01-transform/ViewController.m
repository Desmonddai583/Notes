//
//  ViewController.m
//  01-transform
//
//  Created by xiaomage on 16/1/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)moveUp:(id)sender {
    //平移
    [UIView animateWithDuration:0.5 animations:^{
        //使用Make,它是相对于最原始的位置做的形变.
        //self.imageV.transform = CGAffineTransformMakeTranslation(0, -100);
        //相对于上一次做形变.
        self.imageV.transform = CGAffineTransformTranslate(self.imageV.transform, 0, -100);
    }];
    
}
- (IBAction)moveDown:(id)sender {
    
    //平移
    [UIView animateWithDuration:0.5 animations:^{
        //使用Make,它是相对于最原始的位置做的形变.
        //self.imageV.transform = CGAffineTransformMakeTranslation(0, -100);
        //相对于上一次做形变.
        self.imageV.transform = CGAffineTransformTranslate(self.imageV.transform, 0, 100);
    }];
}

- (IBAction)rotation:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        //旋转(旋转的度数, 是一个弧度)
        //self.imageV.transform = CGAffineTransformMakeRotation(M_PI_4);
        
        self.imageV.transform = CGAffineTransformRotate(self.imageV.transform, M_PI_4);
        
    }];
    
}
- (IBAction)scale:(id)sender {
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
       //缩放
        //self.imageV.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.imageV.transform = CGAffineTransformScale(self.imageV.transform, 0.8, 0.8);
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
