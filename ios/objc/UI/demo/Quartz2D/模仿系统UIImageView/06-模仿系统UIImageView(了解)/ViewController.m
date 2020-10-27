//
//  ViewController.m
//  06-模仿系统UIImageView(了解)
//
//  Created by xiaomage on 16/1/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGImageView.h"

@interface ViewController ()

/** <#注释#> */
@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak)  XMGImageView *xmgImageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    UIImageView *imageV = [[UIImageView alloc] init];
//    imageV.frame  = CGRectMake(0, 0, 200, 200);
//    imageV.image = [UIImage imageNamed:@"CTO"];
//    self.imageV = imageV;
//    [self.view addSubview:imageV];
    
    //initWithImage创建的ImageView的大小跟原始图片一样大
//    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CTO"]];
//    [self.view addSubview:imageV];
    
    
    
    XMGImageView *xmgImageV = [[XMGImageView alloc] initWithImage:[UIImage imageNamed:@"CTO"]];
    [self.view addSubview:xmgImageV];
    
//
//    XMGImageView *xmgImageV = [[XMGImageView alloc] init];
//    xmgImageV.frame  = CGRectMake(0, 0, 200, 200);
//    xmgImageV.image = [UIImage imageNamed:@"CTO"];
//    self.xmgImageV = xmgImageV;
//    [self.view addSubview:xmgImageV];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //self.imageV.image = [UIImage imageNamed:@"汽水"];
    self.xmgImageV.image = [UIImage imageNamed:@"汽水"];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
