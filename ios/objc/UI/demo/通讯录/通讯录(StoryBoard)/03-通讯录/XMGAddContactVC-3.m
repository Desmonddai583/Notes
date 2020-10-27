//
//  XMGAddContactVC-3.m
//  03-通讯录
//
//  Created by xiaomage on 16/1/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGAddContactVC-3.h"
#import "XMGContactItem.h"

@interface XMGAddContactVC_3 ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation XMGAddContactVC_3

//开发当中原则
//1.低耦合(减少控制器之与控制器之间的关联) (解耦)
//2.高内聚(抽取方法)
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.nameTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.phoneTextF addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];

    
    NSLog(@"self.delegate====%@",self.delegate);
    
    [self textChange];
    
}


//当文本框内容发生改变时调用
- (void)textChange {
    
    self.addBtn.enabled = self.nameTextF.text.length && self.phoneTextF.text.length;

}

//点击添加按钮


//传递数据(顺数数据)
//1.数据接收的控制器(XMGContactVC_2)定义一个属性,来接收数据
//2.数据的来源控制器要拿到数据接收的控制器.
//3.给接收的控制器的接收数据的属性给它赋值.
- (IBAction)addBtnClick:(UIButton *)sender {

    //把输入的姓名和电话传递到上一个控制器(XMGContactVC-2)
    //把输入的姓名和电话封装一个模型
    XMGContactItem *contactItem = [XMGContactItem itemWithName:self.nameTextF.text phone:self.phoneTextF.text];
    
    //self.contactVC.contactItem = contactItem;
    
    //判断代理有没有实现协议方法
    if([self.delegate respondsToSelector:@selector(addContactVC:contactItem:)]){
        [self.delegate addContactVC:self contactItem:contactItem];
    }
    
    
    //返回上一级
    [self.navigationController popViewControllerAnimated:YES];
    
}



-(void)dealloc{
    NSLog(@"%s",__func__);
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
