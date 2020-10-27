//
//  ViewController.m
//  13-粒子效果
//
//  Created by xiaomage on 16/1/27.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "VCView.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet VCView *vcView;

@end

@implementation ViewController

- (IBAction)start:(id)sender {
    
    [self.vcView start];
}
- (IBAction)redraw:(id)sender {
    [self.vcView redraw];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
