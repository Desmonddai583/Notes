//
//  ViewController.m
//  03-下载进度条(重绘)(掌握)
//
//  Created by xiaomage on 16/1/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "ProgressView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *valueTitle;
@property (weak, nonatomic) IBOutlet ProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)valueChange:(UISlider *)sender {
    
    //获取进度值
    NSLog(@"%f",sender.value);
    //%在stringWithFormat有特殊的含义,不能直接使用,如果想要使用用两个%代表一个%
    self.valueTitle.text = [NSString stringWithFormat:@"%.2f%%",sender.value * 100];
    
    self.progressView.progressValue = sender.value;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
