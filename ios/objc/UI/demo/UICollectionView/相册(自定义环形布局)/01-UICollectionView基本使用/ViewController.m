//
//  ViewController.m
//  01-UICollectionView基本使用
//
//  Created by yz on 15/11/24.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCell.h"

#import "FlowLayout.h"

#import "CircleLayout.h"

@interface ViewController ()<UICollectionViewDataSource>

@end

@implementation ViewController

static NSString * const ID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 添加collectionView
    [self addCollectionView];
}

- (void)addCollectionView
{
    
    // 创建流水布局
    CircleLayout *flowLayout = [[CircleLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    
    collectionView.backgroundColor = [UIColor greenColor];
    
    collectionView.dataSource = self;
    
    [self.view addSubview:collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    collectionView.showsHorizontalScrollIndicator = NO;
    
    
    
}




#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    NSString *imageName = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    cell.image = [UIImage imageNamed:imageName];
    
    return cell;
}

@end
