//
//  XMGContactVC-2.m
//  03-通讯录
//
//  Created by xiaomage on 16/1/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGContactVC-2.h"
#import "XMGAddContactVC-3.h"
#import "XMGContactItem.h"
#import "XMGEditViC-4.h"

@interface XMGContactVC_2 ()<UIActionSheetDelegate,UIAlertViewDelegate,XMGAddContactVCDelegate>




/** 存放的都是XMGContactItem模型 */
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation XMGContactVC_2


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTalble) name:@"roloadData" object:nil];
    
}

- (void)reloadTalble{
    //刷新表格
    [self.tableView reloadData];
}



-(void)setContactItem:(XMGContactItem *)contactItem{
    _contactItem = contactItem;
    NSLog(@"%@--%@",contactItem.name,contactItem.phone);
    
}

-(void)setAccountName:(NSString *)accountName{
    _accountName = accountName;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@的通讯录",accountName];
    
}



#pragma -mark XMGAddContactVCDelegate
-(void)addContactVC:(XMGAddContactVC_3 *)addContactVC contactItem:(XMGContactItem *)contactItem{
    
    //保存存放的数据
    [self.dataArray addObject:contactItem];
    //刷新表格
    [self.tableView reloadData];
    
    NSLog(@"%@--%@",contactItem.name,contactItem.phone);
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}


//退出登录
- (IBAction)loginOut:(id)sender {
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定要退出登录嘛?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定退出" otherButtonTitles:nil];
//    
//    [actionSheet showInView:self.view];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定要退出登录嘛?"  message:@"message" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//    
//    [alert show];
    
    
    //第一步:创建控制器
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定要退出嘛?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //第二步:创建按钮
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    
        [self.navigationController popViewControllerAnimated:YES];
    }];
    //第三步:添加按钮
    [alertVC addAction:action];
    [alertVC addAction:action1];
    //第四步:显示弹框.(相当于show操作)'
    [self presentViewController:alertVC animated:YES completion:nil];
  
    
    
}


//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    
//    if (buttonIndex == 0) {
//        //退出
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    
//}
//
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    if (buttonIndex == 1) {
//        //退出
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    
//
//}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.destinationViewController isKindOfClass:[XMGAddContactVC_3 class]]) {
        XMGAddContactVC_3 *addVC =  (XMGAddContactVC_3 *)segue.destinationViewController;
        //addVC.contactVC = self;
        addVC.delegate = self;
    }else{
        
        XMGEditViC_4 *editVC =  (XMGEditViC_4 *)segue.destinationViewController;
        //把当前选中的行模型传递给编辑控制器
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        XMGContactItem *item = self.dataArray[indexPath.row];
        editVC.contactItem = item;
        
        
        
    }
   
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return   self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *ID = @"CELLID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
//    }
    //取出当前行模型
    XMGContactItem *item =  self.dataArray[indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.phone;
    return  cell;
}



-(void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
