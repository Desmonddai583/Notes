//
//  ViewController.m
//  04-归档(掌握)
//
//  Created by xiaomage on 16/1/19.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Dog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)save:(id)sender {
    
    Person *per =  [[Person alloc] init];
    per.name = @"xmg";
    per.age = 10;
    
    Dog *dog = [[Dog alloc] init];
    dog.name = @"wangcai";
    per.dog = dog;
    
    
    
    //获取沙盒目录
    NSString *tempPath =  NSTemporaryDirectory();
    NSString *filePath = [tempPath stringByAppendingPathComponent:@"Person.data"];
    NSLog(@"%@",tempPath);
    
    //归档 archiveRootObject会调用encodeWithCoder:
    [NSKeyedArchiver archiveRootObject:per toFile:filePath];
    
    
}
- (IBAction)read:(id)sender {
    
    //获取沙盒目录
    NSString *tempPath =  NSTemporaryDirectory();
    NSString *filePath = [tempPath stringByAppendingPathComponent:@"Person.data"];
    //unarchiveObjectWithFile会调用initWithCoder
    Person *per = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"%@---%@",per.name,per.dog.name);

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
