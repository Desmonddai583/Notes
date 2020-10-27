//
//  XMGNewFeatreCollectionViewController.m
//  小码哥彩票
//
//  Created by simplyou on 15/11/13.
//  Copyright © 2015年 simplyou. All rights reserved.
//

#import "XMGNewFeatreCollectionViewController.h"
#import "XMGNewFeatureCollectionViewCell.h"

@interface XMGNewFeatreCollectionViewController ()
/**
 *  记录上次偏差
 */
@property (nonatomic, assign) CGFloat lastOffsetX;

@property (nonatomic, weak) UIImageView *guideImageView;
/**
 *  底部大标题
 */
@property (nonatomic, weak) UIImageView *guideLargeTextImageView;
/**
 *  底部小标题
 */
@property (nonatomic, weak) UIImageView *guideSmallTextImageView;
@end

@implementation XMGNewFeatreCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

// 1.创建布局参数

// 2.注册cell

// 3.自定义cell
#define XMGBounds [UIScreen mainScreen].bounds

- (instancetype)init{
    // 创建流水布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 行间距
    flowLayout.minimumLineSpacing = 0;
    // 每个item 之间的间距
    flowLayout.minimumInteritemSpacing = 0;

    // 设置每个cell 的尺寸
    flowLayout.itemSize = XMGBounds.size;
    
    // 设置滚动方向 水平滚动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
//    flowLayout.sectionInset = UIEdgeInsetsMake(100, 20, 30, 40);
    
    return [super initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[XMGNewFeatureCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // self.collectionView !=  self.view
    // self.collectionView 添加到 self.view上面
    self.view.backgroundColor = [UIColor redColor];
    self.collectionView.backgroundColor = [UIColor yellowColor];
    
    // 设置分页
    self.collectionView.pagingEnabled = YES;
    // 取消弹簧效果
    self.collectionView.bounces = NO;
    // 取消滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    // 添加图片
    [self addImageView];
}
// 添加图片 添加到 collectionView 上
- (void)addImageView{
    // guide1
    UIImageView *guideImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide1"]];
    [self.collectionView addSubview:guideImageView];
    guideImageView.x += 50;
    self.guideImageView = guideImageView;
    
    // guideLine
    UIImageView *guideLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideLine"]];
    [self.collectionView addSubview:guideLineImageView];
    guideLineImageView.x -= 150;
    
    // guideLargeText1
    UIImageView *guideLargeTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideLargeText1"]];
    [self.collectionView addSubview:guideLargeTextImageView];
    guideLargeTextImageView.center = CGPointMake(self.collectionView.width * 0.5f, self.collectionView.height * 0.7);
    self.guideLargeTextImageView = guideLargeTextImageView;
    
    // guideSmallText1
    UIImageView *guideSmallTextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideSmallText1"]];
    [self.collectionView addSubview:guideSmallTextImageView];
    guideSmallTextImageView.center = CGPointMake(self.collectionView.width * 0.5f, self.collectionView.height * 0.8);
    self.guideSmallTextImageView = guideSmallTextImageView;
}
// 当scrollView 减速的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 平移一个偏差
    // 当前偏差
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 计算页码
    NSInteger page = offsetX / scrollView.width + 1;
    
    // 换图片
    NSString *name = [NSString stringWithFormat:@"guide%ld",page];
    UIImage *image = [UIImage imageNamed:name];
    self.guideImageView.image = image;
    
    // 大标题
    NSString *largeTextname = [NSString stringWithFormat:@"guideLargeText%ld",page];
    UIImage *largeTextimage = [UIImage imageNamed:largeTextname];
    self.guideLargeTextImageView.image = largeTextimage;
    
    // 小标题
    NSString *smallTextname = [NSString stringWithFormat:@"guideSmallText%ld",page];
    UIImage *smallTextimage = [UIImage imageNamed:smallTextname];
    self.guideSmallTextImageView.image = smallTextimage;
    
    // 偏差值
    CGFloat del = offsetX - self.lastOffsetX;
    
    self.guideImageView.x += del * 2;
    self.guideLargeTextImageView.x += del * 2;
    self.guideSmallTextImageView.x += del * 2;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.guideImageView.x -= del;
        self.guideLargeTextImageView.x -= del;
        self.guideSmallTextImageView.x -= del;
    }];
    
    // 记录上次偏差
    self.lastOffsetX = offsetX;
}
#pragma mark <UICollectionViewDataSource>
// 一共有几组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
#define XMGPage 4

// 有多个items
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return XMGPage;
}
// 每一个items显示什么样子
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMGNewFeatureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"guide%ldBackground",indexPath.item + 1];
    
    cell.image = [UIImage imageNamed:imageName];
    
    // 判断是否是最后一个cell
    [cell setIndexPath:indexPath count:XMGPage];
    
    return cell;
}


@end
