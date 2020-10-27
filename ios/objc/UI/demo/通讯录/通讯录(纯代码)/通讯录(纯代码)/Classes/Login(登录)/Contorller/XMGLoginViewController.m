//
//  XMGLoginViewController.m
//  通讯录(纯代码)
//
//  Created by xiaomage on 16/1/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGLoginViewController.h"
#import "MBProgressHUD+XMG.h"
#import "XMGContactVC.h"


#define XMGAccount @"account"
#define XMGPwd @"pwd"
#define XMGIsAutoLogin @"isAutoLogin"
#define XMGIsRem @"isRem"


@interface XMGLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UISwitch *remSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;

@end

@implementation XMGLoginViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"欢迎进入通讯录";
    
    //先从沙盒当中取出保存的设置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.remSwitch.on = [defaults boolForKey:XMGIsRem];
    self.autoLoginSwitch.on = [defaults boolForKey:XMGIsAutoLogin];
    
    if (self.remSwitch.on) {
        self.accountTextF.text = [defaults objectForKey:XMGAccount];
        self.pwdTextF.text = [defaults objectForKey:XMGPwd];
        
        if (self.autoLoginSwitch.on) {
            //要自动登录
            [self loginBtnC:self.loginBtn];
        }
    }
    

    [self.accountTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    
    //手动判断账号跟密码是否有值
    [self textChange];
    
}


//当文本框内容发生改变时调用
- (void)textChange{
    
    //    if (self.accoutTextF.text.length && self.pwdTextF.text.length) {
    //        //让登录按钮能够点击
    //        self.loginBtn.enabled = YES;
    //    }else{
    //        self.loginBtn.enabled = NO;
    //    }
    //
    self.loginBtn.enabled = self.accountTextF.text.length && self.pwdTextF.text.length;
    
}



- (IBAction)loginBtnC:(id)sender {
    
    
    //如果用户名跟密码正确,跳转到下一个界面
    //提醒用户正在登录
    [MBProgressHUD showMessage:@"哥正在帮你登录..." toView:self.view];
    
    //延时执行任务
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([self.accountTextF.text isEqualToString:@"xmg"] && [self.pwdTextF.text isEqualToString:@"123"]) {
            
            //保存用户名和密码到沙盒里
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:self.accountTextF.text forKey:XMGAccount];
            [defaults setObject:self.pwdTextF.text forKey:XMGPwd];
            [defaults setBool:self.remSwitch.on forKey:XMGIsRem];
            [defaults setBool:self.autoLoginSwitch.on forKey:XMGIsAutoLogin];
            
            //立马写入到文件
            [defaults synchronize];
            
            
            NSLog(@"%@",NSHomeDirectory());
            
            //隐藏HUD
            [MBProgressHUD hideHUDForView:self.view];
            
            XMGContactVC *contactVC = [[XMGContactVC alloc] init];
            contactVC.name = self.accountTextF.text;
            [self.navigationController pushViewController:contactVC animated:YES];
            
            
        }else{
            //提醒用户
            NSLog(@"用户名或密码");
            //隐藏HUD
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"用户名或密码"];
        }
        
    });
    
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
