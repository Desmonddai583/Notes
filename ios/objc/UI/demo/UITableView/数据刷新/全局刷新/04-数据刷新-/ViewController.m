//
//  ViewController.m
//  04-数据刷新-
//
//  Created by xiaomage on 16/1/11.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGWineCell.h"
#import "MJExtension.h"
#import "XMGWine.h"

@interface ViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 酒数据 */
@property (nonatomic, strong) NSMutableArray *wineArray;
@end

@implementation ViewController

- (NSMutableArray *)wineArray
{
    if (!_wineArray) {
        
        _wineArray = [XMGWine mj_objectArrayWithFilename:@"wine.plist"];
    }
    return _wineArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - 按钮的点击
- (IBAction)add {
    // 修改模型
    XMGWine *wine = [[XMGWine alloc] init];
    wine.image = @"newWine";
    wine.money = @"55.5";
    wine.name = @"女儿红";
//    [self.wineArray addObject:wine];
    [self.wineArray insertObject:wine atIndex:0];
    
    // 告诉tableView数据变了,赶紧刷新(全局刷新)
    [self.tableView reloadData];
}
- (IBAction)remove {
    // 修改模型
    [self.wineArray removeObjectAtIndex:0];
    [self.wineArray removeObjectAtIndex:0];
    
    // 告诉tableView数据变了,赶紧刷新
    [self.tableView reloadData];
}

- (IBAction)update {
    // 修改模型
    XMGWine *wine = self.wineArray[0];
    wine.money = @"100";
    
    // 告诉tableView数据变了,赶紧刷新
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"wine";
    XMGWineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[XMGWineCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.wine = self.wineArray[indexPath.row];
    return cell;
}

@end
