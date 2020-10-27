//
//  ViewController.m
//  02-UIApplication单例(了解)
//
//  Created by xiaomage on 16/1/14.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


//    UIApplication *app =  [UIApplication sharedApplication];
//    UIApplication *app2 =  [UIApplication sharedApplication];
//    NSLog(@"%p---%p",app,app2);
    //UIApplication *app3 =  [[UIApplication alloc] init];
    
    Person *per1 = [Person sharedPerson];
    Person *per2 = [Person sharedPerson];
    NSLog(@"per1==%p---per2==%p",per1,per2);
    
    Person *per3 = [[Person alloc] init];
    NSLog(@"per1==%p---per2==%p per3===%p",per1,per2,per3);

    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
