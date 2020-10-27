//
//  ViewController.m
//  01-索引条
//
//  Created by xiaomage on 16/1/8.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGCarGroup.h"
#import "XMGCar.h"
#import "MJExtension.h"

@interface ViewController ()
/** 所有的车数据 */
@property (nonatomic, strong) NSArray *carGroups;
@end

@implementation ViewController

- (NSArray *)carGroups
{
    if (!_carGroups) {
//        // 1.加载字典数组
//        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cars.plist" ofType:nil]];
//        
//        // 2.字典数组->模型数组
//        NSMutableArray *temp = [NSMutableArray array];
//        for (NSDictionary *carGroupDict in dictArray) {
//            [temp addObject:[XMGCarGroup carGroupWithDict:carGroupDict]];
//        }
        // 告诉MJExtension这个框架XMGCarGroup的cars数组属性装的是XMGCar对象
        [XMGCarGroup mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"cars" : [XMGCar class]};
        }];
        
        _carGroups = [XMGCarGroup mj_objectArrayWithFilename:@"cars.plist"];
    }
    
    return _carGroups;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 设置索引条的文字颜色
    self.tableView.sectionIndexColor = [UIColor redColor];
    
    // 设置索引条的背景颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor yellowColor];
}

// 隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.carGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XMGCarGroup *group = self.carGroups[section];
    return group.cars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.访问缓存池
    static NSString *ID = @"car";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 2.缓存池没有,自己创建
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    // 3.设置数据
    XMGCarGroup *group = self.carGroups[indexPath.section];
    XMGCar *car = group.cars[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:car.icon];
    cell.textLabel.text = car.name;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    XMGCarGroup *group = self.carGroups[section];
    return group.title;
}

/**
 *  返回索引条的文字
 */
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    NSMutableArray *titles = [NSMutableArray array];
//    for (XMGCarGroup *group in self.carGroups) {
//        [titles addObject:group.title];
//    }
//    
//    return titles;
    
    // 抽取self.carGroups 这个数组中每一个元素(XMGCarGroup对象)的title属性的值,放在一个新的数组中返回
    return [self.carGroups valueForKeyPath:@"title"];
}












@end
