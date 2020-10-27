//
//  ViewController.m
//  备课07-自定义不等高的cell-frame
//
//  Created by FTD_ZHC on 15/9/22.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGStatus.h"
#import "XMGStatusCell.h"
#import "XMGStatusFrame.h"

@interface ViewController ()
/** frame模型数组 */
@property (nonatomic ,strong)NSArray *statusFrames;
@end

@implementation ViewController

- (NSArray *)statusFrames
{
    if (!_statusFrames) {
        // 加载plist
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"statuses.plist" ofType:nil]];
        
        // 字典数组->模型数组
        NSMutableArray *frameArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            XMGStatus *status = [XMGStatus statusWithDict:dict];
            XMGStatusFrame *stausFrame = [[XMGStatusFrame alloc] init];
            // 传递模型数据给frame模型,重写setter方法,在这一刻就能计算好这个模型对应的cell的高度和子控件的frame
            stausFrame.status = status;
            [frameArray addObject:stausFrame];
        }
        _statusFrames = frameArray;
    }
    return _statusFrames;
}

NSString *ID = @"status";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[XMGStatusCell class] forCellReuseIdentifier:ID];
}

#pragma mark - 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMGStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 传递模型数据(传递的frame模型,因为这个模型中既有模型数据,又有算好的这个cell子控件的frame和cell的高度)
    cell.statusFrame = self.statusFrames[indexPath.row];
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出这行的模型
    XMGStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    return statusFrame.cellHeight;
}
@end
