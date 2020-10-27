//
//  ViewController.m
//  12-掌握-UIWebView的基本使用
//
//  Created by xiaomage on 16/2/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test5];
}

-(void)test1
{
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    //加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)test2
{
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    //加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
}

//加载本地的文件
-(void)test3
{
    NSURL *url = [NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/07-NSURLSession.pptx"];
    //加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)test4
{
    NSURL *url = [NSURL URLWithString:@"http://www.520it.com/"];
    //加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //设置时候自适应
    self.webView.scalesPageToFit = YES;
}

-(void)test5
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"text.html" withExtension:nil];
    
    //加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //设置时候自适应
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
}
@end
