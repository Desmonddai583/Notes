//
//  ViewController.m
//  13-掌握-UIWebView应用小案例
//
//  Created by xiaomage on 16/2/26.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForward;

@end

@implementation ViewController

#pragma mark ----------------------
#pragma mark Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //加载网页
    [self.webView loadRequest:request];
    
    //设置代理
    self.webView.delegate = self;
}

#pragma mark ----------------------
#pragma mark Events
- (IBAction)goBackBtnClick:(id)sender
{
    
    [self.webView goBack];
}
- (IBAction)goForwardBtnClick:(id)sender
{
    [self.webView goForward];
    
}
- (IBAction)reloadBtnClick:(id)sender
{
    [self.webView reload];
}

#pragma mark ----------------------
#pragma mark UIWebViewDelegate

//即将加载某个请求的时候调用
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",request.URL.absoluteString);
    //简单的请求拦截处理
    NSString *strM = request.URL.absoluteString;
    if ([strM containsString:@"360"]) {
        return NO;
    }
    return YES;
}

//1.开始加载网页的时候调用
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}

//2.加载完成的时候调用
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
    self.goBack.enabled = self.webView.canGoBack;
    self.goForward.enabled = self.webView.canGoForward;
}

//3.加载失败的时候调用
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError");
}

@end
