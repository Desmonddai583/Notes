//
//  ViewController.m
//  02-CATransform3D(了解)
//
//  Created by xiaomage on 16/1/26.
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



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //3D效果
    [UIView animateWithDuration:0.5 animations:^{
        
        //self.imageV.layer.transform = CATransform3DMakeRotation(M_PI, 1, 1, 0);
        
        //把结构体转成对象
        NSValue *value = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 1, 1, 0)];
        
        //通过KVC一般是做快速旋转,平移,缩放
        [self.imageV.layer setValue:@(100) forKeyPath:@"transform.translation.x"];
        
    }];
    
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
