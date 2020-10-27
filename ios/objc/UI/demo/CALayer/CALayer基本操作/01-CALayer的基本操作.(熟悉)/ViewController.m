//
//  ViewController.m
//  01-CALayer的基本操作.(熟悉)
//
//  Created by xiaomage on 16/1/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    //设置阴影的颜色
    self.imageV.layer.shadowColor = [UIColor blueColor].CGColor;
    //设置阴影的不透明度
    self.imageV.layer.shadowOpacity = 1;
    self.imageV.layer.shadowOffset = CGSizeMake(10, 10);
    //设置阴影的模糊的半径
    self.imageV.layer.shadowRadius = 5;

    
    //边框宽度,往里边走的.
    self.imageV.layer.borderWidth = 2;
    self.imageV.layer.borderColor = [UIColor greenColor].CGColor;
    
    
    
    //设置圆角
    self.imageV.layer.cornerRadius = 50;
    //把超过根层以外的东西都给裁剪掉(UIview自带的层,我们称它是根层)
    self.imageV.layer.masksToBounds = YES;
    
    NSLog(@"%@",self.imageV.layer.contents);

}


- (void)UIViewLayer {
    //设置阴影的颜色
    self.redView.layer.shadowColor = [UIColor blueColor].CGColor;
    //设置阴影的不透明度
    self.redView.layer.shadowOpacity = 1;
    self.redView.layer.shadowOffset = CGSizeMake(-30, -30);
    //设置阴影的模糊的半径
    self.redView.layer.shadowRadius = 5;
    
    //边框宽度,往里边走的.
    self.redView.layer.borderWidth = 2;
    self.redView.layer.borderColor = [UIColor greenColor].CGColor;
    
    
    //设置圆角
    self.redView.layer.cornerRadius = 50;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
