//
//  ViewController.m
//  02-展示汽车数据
//
//  Created by xiaomage on 16/1/7.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGCarGroup.h"
#import "XMGCar.h"

@interface ViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 所有的车数据 */
@property (nonatomic, strong) NSArray *carGroups;
@end

@implementation ViewController

/********************************************************
 1> plist解析:
 以后遇到像这种复杂的plist,一层一层的往下解析.
 最终的目的就是将所有的字典转成模型.
 如果plist中字典在一个数组中,将来转出来的模型也放在一个数组中.
 也就是将字典数组转成模型数组.
 
 2> plist的好处:方便管理数据
 *******************************************************/
// plist
- (NSArray *)carGroups
{
    if (!_carGroups) {
        // 1.加载字典数组
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cars" ofType:@"plist"]];
        
        // 2.创建模型数组
        NSMutableArray *temp = [NSMutableArray array];
        // 3.字典数组 -> 模型数组
        for (NSDictionary *carGroupDict in dictArray) {
            XMGCarGroup *group = [XMGCarGroup carGroupWithDict:carGroupDict];
            [temp addObject:group];
        }
        
        _carGroups = temp;
    }
    return _carGroups;
}

// 业务逻辑
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.carGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 取出第section组的组模型
    XMGCarGroup *group = self.carGroups[section];
    return group.cars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    // 设置cell右边的指示样式
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // 取出indexPath.secton这组的组模型
    XMGCarGroup *group = self.carGroups[indexPath.section];
    
    // 取出indexPath.row对应的车模型
    XMGCar *car = group.cars[indexPath.row];
    
    // 设置数据
    cell.textLabel.text = car.name;
    cell.imageView.image = [UIImage imageNamed:car.icon];
    
     return cell;
}

/**
 *  告诉tableView每一组的头部标题
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // 取出第section组的组模型
    XMGCarGroup *group = self.carGroups[section];
    return group.header;
}

/**
 *  告诉tableView每一组的尾部标题
 */
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    // 取出第section组的组模型
    XMGCarGroup *group = self.carGroups[section];
    return group.footer;
}
@end
