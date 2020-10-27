//
//  ViewController.m
//  05-展示单组数组
//
//  Created by xiaomage on 16/1/7.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGWine.h"

@interface ViewController () <UITableViewDataSource>

/** 所有的酒数据 */
@property (nonatomic, strong) NSArray *wineArray;
@end

@implementation ViewController

- (NSArray *)wineArray
{
    if (!_wineArray) {
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wine.plist" ofType:nil]];
        
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *wineDict in dictArray) {
            [temp addObject:[XMGWine wineWithDict:wineDict]];
        }
        
        _wineArray = temp;
    }
    return _wineArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UITableViewDataSource
// 如果不实现,默认是1组
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

// section == 0
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 取出indexPath 对应的酒模型
    XMGWine *wine = self.wineArray[indexPath.row];
    
    // 设置数据
    cell.textLabel.text = wine.name;
    cell.imageView.image = [UIImage imageNamed:wine.image];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",wine.money];
    cell.detailTextLabel.textColor = [UIColor orangeColor];
    return cell;
}
@end
