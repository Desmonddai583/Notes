//
//  ViewController.m
//  02-偏好设置(掌握)
//
//  Created by xiaomage on 16/1/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)save:(id)sender {
    
    
    //NSUserDefaults它保存也是一个plist.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"xmg" forKey:@"name"];
    [defaults setInteger:10 forKey:@"age"];

    //立马写入到文件当中
    [defaults synchronize];
    
    
    NSLog(@"%@",NSHomeDirectory());
    
}

- (IBAction)read:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [defaults objectForKey:@"name"];
    NSLog(@"name ===%@",name);
    NSInteger age = [defaults integerForKey:@"age"];
    NSLog(@"%ld",age);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
