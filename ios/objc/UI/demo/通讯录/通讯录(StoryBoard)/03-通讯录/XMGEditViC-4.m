//
//  XMGEditViC-4.m
//  03-通讯录
//
//  Created by xiaomage on 16/1/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGEditViC-4.h"
#import "XMGContactItem.h"

@interface XMGEditViC_4 ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation XMGEditViC_4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameTextF.text = self.contactItem.name;
    self.phoneTextF.text = self.contactItem.phone;
    
}


- (IBAction)editClick:(UIBarButtonItem *)sender {
    
    
    if ([sender.title  isEqualToString:@"编辑"]) {
        self.phoneTextF.enabled = YES;
        self.nameTextF.enabled = YES;
        //电话文本框成为第一响应者
        [self.phoneTextF becomeFirstResponder];
        //保存按钮显示
        self.saveBtn.hidden = NO;
        //把编辑按钮的文字改为取消
        sender.title = @"取消";
    }else{
        self.phoneTextF.enabled = NO;
        self.nameTextF.enabled =  NO;
        [self.view endEditing:YES];
        self.saveBtn.hidden = YES;
        sender.title = @"编辑";
        //恢复之前的数据
        self.nameTextF.text = self.contactItem.name;
        self.phoneTextF.text = self.contactItem.phone;

    }
    
}
- (IBAction)saveBtnClick:(id)sender {
    
    //修改模型
    self.contactItem.name = self.nameTextF.text;
    self.contactItem.phone = self.phoneTextF.text;
    
    //通知上一个控制器刷新列表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"roloadData" object:nil userInfo:nil];
    //返回上一级
    [self.navigationController popViewControllerAnimated:YES];
    
}

//-(void)setContactItem:(XMGContactItem *)contactItem{
//    _contactItem = contactItem;
//    
//  
//    
//}


@end
