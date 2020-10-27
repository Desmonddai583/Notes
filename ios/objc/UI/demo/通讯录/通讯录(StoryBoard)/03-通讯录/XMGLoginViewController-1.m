//
//  XMGLoginViewController-1.m
//  03-通讯录
//
//  Created by xiaomage on 16/1/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGLoginViewController-1.h"
#import "MBProgressHUD+XMG.h"
#import "XMGContactVC-2.h"

@interface XMGLoginViewController_1 ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accoutTextF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *remPwdSwitch;

@end

@implementation XMGLoginViewController_1

//登录按钮点击
- (IBAction)loginBtnClick:(UIButton *)sender {

    
    //如果用户名跟密码正确,跳转到下一个界面
    //提醒用户正在登录
    [MBProgressHUD showMessage:@"哥正在帮你登录..." toView:self.view];
    
    //延时执行任务
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([self.accoutTextF.text isEqualToString:@"xmg"] && [self.pwdTextF.text isEqualToString:@"123"]) {
            //隐藏HUD
            [MBProgressHUD hideHUDForView:self.view];
            //跳转到下一个界面
            //手动去执行线(segue)
            [self performSegueWithIdentifier:@"contactVC" sender:nil];
            
        }else{
            //提醒用户
            NSLog(@"用户名或密码");
            //隐藏HUD
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"用户名或密码"];
        }
        
    });
    
    
    /**
     performSegueWithIdentifier底层实现
     1.到StoryBoard当中去查找有没有给定标识的segue.
     2.根据指定的标识,创建一个UIStoryboardSegue对象之后, 把当前的控制器,给它源控制器属性赋值(segue.sourceViewController).
     3.UIStoryboardSegue对象,再去创建它的目标控制器.给UIStoryboardSegue的目标控制器属性(segue.destinationViewController)赋值
     4.调用当前控制器prepareForSegue:方法,告诉用户,当前的线已经准备好了.
     5.[segue perform]
       [segue.sourceViewController.navigationController pushViewController:segue.destinationViewController animated:YES];
     */
}

//准备跳转前调用
//做一些传递数据.
//传递数据(顺数数据)
//1.数据接收的控制器(XMGContactVC_2)定义一个属性,来接收数据
//2.数据的来源控制器要拿到数据接收的控制器.
//3.给接收的控制器的接收数据的属性给它赋值.

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //要跳转的目标控制器
    NSLog(@"%@",segue.destinationViewController);
    //源控制器
    NSLog(@"%@",segue.sourceViewController);
    
    
    XMGContactVC_2 *contactVC = (XMGContactVC_2 *)segue.destinationViewController;
    contactVC.accountName = self.accoutTextF.text;
    
    //[segue perform];
    //[segue.sourceViewController.navigationController pushViewController:segue.destinationViewController animated:YES];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听账号跟密码同时有值的时候,让登录按钮能够点击
//    self.accoutTextF.delegate = self;
//    self.pwdTextF.delegate = self;
    [self.accoutTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
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
    self.loginBtn.enabled = self.accoutTextF.text.length && self.pwdTextF.text.length;
    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    if (self.accoutTextF.text.length && self.pwdTextF.text.length) {
//        //让登录按钮能够点击
//        self.loginBtn.enabled = YES;
//    }else{
//        self.loginBtn.enabled = NO;
//    }
//    
//    NSLog(@"%@",string);
//    NSLog(@"---%@",self.pwdTextF.text);
//    
//    return YES;
//}


//记住密码开关发生改变
- (IBAction)remPwdChange:(UISwitch *)sender {

    if(self.remPwdSwitch.on == NO){
        //self.autoLoginSwitch.on = NO;
        [self.autoLoginSwitch setOn:NO animated:YES];
    }
}


//自动登录开关发生改变
- (IBAction)autoLoginChange:(UISwitch *)sender {
    
    if (self.autoLoginSwitch.on == YES) {
        [self.remPwdSwitch setOn:YES animated:YES];
    }
    
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
