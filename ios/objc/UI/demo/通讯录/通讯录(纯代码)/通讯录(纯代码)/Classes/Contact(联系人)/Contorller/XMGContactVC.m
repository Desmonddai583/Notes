//
//  XMGContactVC.m
//  通讯录(纯代码)
//
//  Created by xiaomage on 16/1/18.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGContactVC.h"
#import "XMGAddContactVC.h"
#import "XMGContactItem.h"
#import "XMGEditVC.h"



@interface XMGContactVC ()<XMGAddContactVCDelegate>

/** 存放的都是XMGContactItem模型 */
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation XMGContactVC


-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@-的通讯录",self.name];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:0 target:self action:@selector(loginOut)];
    
       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:0 target:self action:@selector(addContact)];
    
    
    
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTalble) name:@"roloadData" object:nil];
}

- (void)reloadTalble{
    //刷新表格
    [self.tableView reloadData];
}




- (void)addContact{
    
    XMGAddContactVC *addVC = [[XMGAddContactVC alloc] init];
    addVC.delegate = self;
    [self.navigationController pushViewController:addVC animated:YES];
    
}


-(void)addContactVC:(XMGAddContactVC *)addContactVC contactItem:(XMGContactItem *)contactItem{

    //保存存放的数据
    [self.dataArray addObject:contactItem];
    //刷新表格
    [self.tableView reloadData];

    
}



//退出登录
- (void)loginOut{
    
    
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return   self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"CELLID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    //取出当前行模型
    XMGContactItem *item =  self.dataArray[indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.phone;
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XMGContactItem *item = self.dataArray[indexPath.row];
    
    XMGEditVC *eidtVC = [[XMGEditVC alloc] init];
    eidtVC.contactItem = item;
    
    [self.navigationController pushViewController:eidtVC animated:YES];
    
    
}

-(void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
