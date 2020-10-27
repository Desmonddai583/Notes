//
//  ViewController.m
//  07-掌握-登录案例
//
//  Created by xiaomage on 16/2/22.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "SVProgressHUD.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF; //用户名
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;      //密码
@end

@implementation ViewController

- (IBAction)loginBtnClick:(id)sender
{
    //添加灰色的背景遮罩
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    //0.拿到用户输入
    NSString *usernameStr = self.usernameTF.text;
    NSString *pwdStr = self.pwdTF.text;
    
    //输入校验(用户名和密码不能为空)
    if (usernameStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:self.usernameTF.placeholder];
        return;
    }
    
    if (pwdStr.length == 0) {
        [SVProgressHUD showErrorWithStatus:self.pwdTF.placeholder];
        return;
    }
    
    
    //1.确定url
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://120.25.226.186:32812/login?username=%@&pwd=%@&type=JSON",usernameStr,pwdStr]];
    
    //2.创建请求对象(GET)
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //[SVProgressHUD show];
    [SVProgressHUD showWithStatus:@"客官别急,下一个轮到你"];
    
    //3.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (connectionError) {
            NSLog(@"请求失败");
            return ;
        }
        
        //4.解析数据
        NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",result);
        
        //5.截取字符串
        NSUInteger loc = [result rangeOfString:@":\""].location + 2;
        NSUInteger len =  [result rangeOfString:@"\"}"].location - loc;
                          
        NSString *msg = [result substringWithRange:NSMakeRange(loc, len)];
        
        //延迟执行,弹框提示用户登录请求结果
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //SVProgressHUD dismiss];
            
            //containsString 方法用于检查字符串包含
            if ([result containsString:@"error"]) {
                [SVProgressHUD showErrorWithStatus:msg];
            }else
            {
               [SVProgressHUD showSuccessWithStatus:msg];
            }
        });
    }];
    
}

@end
