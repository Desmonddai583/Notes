//
//  ViewController.m
//  自定义流水布局
//
//  Created by xiaomage on 16/3/9.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCell.h"
#import "FlowLayout.h"
// UICollectionView使用注意点
// 1.创建UICollectionView必须要有布局参数
// 2.cell必须通过注册
// 3.cell必须自定义,系统cell没有任何子控件
@interface ViewController ()<UICollectionViewDataSource>

@end

@implementation ViewController
#define ScreenW [UIScreen mainScreen].bounds.size.width
static NSString * const ID = @"cell";
// 函数式编程思想(高聚合):把很多功能放在一个函数块(block块)去处理
// 编程思想:低耦合,高聚合(代码聚合,方便去管理)
/*
 int o = (3,5);
 
 int c = ({
 int a = 2;
 int b = 3;
 int q = 3;
 int w = 3;
 int e = 3;
 6;
 });
 NSLog(@"%d",c);
 
 int a = 2;
 int b = 3;
 int w = 3;
 int e = 3;
 int q = 3;
 int c1 = a + b;

 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 利用布局就做效果 => 如何让cell尺寸不一样 => 自定义流水布局
    // 流水布局:调整cell尺寸
    FlowLayout *layout = ({
        
        FlowLayout *layout = [[FlowLayout alloc] init];
        
        // 设置尺寸
        layout.itemSize = CGSizeMake(160, 160);
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat margin = (ScreenW - 160) * 0.5;
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
        // 设置最小行间距
        layout.minimumLineSpacing = 50;
        layout;
        
    });
    
    // 创建UICollectionView:黑色
    UICollectionView *collectionView = ({
        
      UICollectionView *collectionView =  [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor brownColor];
        collectionView.center = self.view.center;
        collectionView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, 200);
        collectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:collectionView];
        
        // 设置数据源
        collectionView.dataSource = self;
        
        collectionView;
        
    });
    
    // 注册cell
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PhotoCell class])  bundle:nil] forCellWithReuseIdentifier:ID];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    NSString *imageName = [NSString stringWithFormat:@"%ld",indexPath.item + 1];
    
    cell.image = [UIImage imageNamed:imageName];
    
    return cell;
}
@end
