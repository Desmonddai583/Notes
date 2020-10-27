//
//  XMGNewFeatureCollectionViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 16/1/30.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGNewFeatureCollectionViewController.h"
#import "XMGNewFeatureCollectionViewCell.h"

@interface XMGNewFeatureCollectionViewController ()
/** 记录上一次偏移量 */
@property (nonatomic, assign) CGFloat lastOffsetX;


@property (nonatomic, weak) UIImageView *guide;
@end

@implementation XMGNewFeatureCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
- (instancetype)init{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 修改item的大小
    flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
    
    // 修改行间距
    flowLayout.minimumLineSpacing = 0;
    
    // 修改每一个item的间距
    flowLayout.minimumInteritemSpacing = 0;
    
    // 修改滚动方向水平
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 修改每一组的边距
//    flowLayout.sectionInset = UIEdgeInsetsMake(100, 20, 30, 40);
    
    return [super initWithCollectionViewLayout:flowLayout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.collectionView != self.view
    // self.collectionView 添加到 self.view
    self.view.backgroundColor = [UIColor yellowColor];
    
    self.collectionView.backgroundColor = [UIColor redColor];
//    
//    self.collectionView.width = 100;
//    self.collectionView.height = 100;
//    
    
    // 注册cell
    [self.collectionView registerClass:[XMGNewFeatureCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 设置分页
    self.collectionView.pagingEnabled = YES;
    // 禁止弹簧效果
    self.collectionView.bounces = NO;
    // 隐藏滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    // 添加内容
    // 1.添加图片
    // 2.添加到哪里 collectionView
    
    [self setupAddChildImageView];
    
    
    
    
    
}
// 添加所有的子控件
- (void)setupAddChildImageView{
    // 1.线
    UIImageView *guideLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideLine"]];
    [self.collectionView addSubview:guideLine];
    guideLine.x -= 150;
    
    // 2.球
    UIImageView *guide = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide1"]];
    [self.collectionView addSubview:guide];
    guide.x += 50;
    self.guide = guide;
    
    // 3.大标题 guideLargeText
    UIImageView *guideLargeText = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideLargeText1"]];
    [self.collectionView addSubview:guideLargeText];
    guideLargeText.center = CGPointMake(self.view.width / 2, self.view.height * 0.7f );
    
    
    // 4.小标题 guideSmallText
    UIImageView *guideSmallText = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideSmallText1"]];
    [self.collectionView addSubview:guideSmallText];
    guideSmallText.center = CGPointMake(self.view.width / 2, self.view.height * 0.8f );
}
//滑动减速的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    // 平移一个屏幕宽度
    
    // 总偏移量
    CGFloat offestX = scrollView.contentOffset.x;
    
    NSLog(@"总偏移量 %f",offestX);
    
    // 计算一个偏移量
    CGFloat del = offestX - self.lastOffsetX;
    NSLog(@"一个偏移量 %f",del);
    
    // 切换图片
    // 计算页码
    NSInteger page = offestX / del;
    
    NSString *name = [NSString stringWithFormat:@"guide%ld",page + 1];
    self.guide.image = [UIImage imageNamed:name];
    
    
    // 偏移子控件
    self.guide.x += del * 2;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.guide.x -= del;
        
    }];
    
    
    self.lastOffsetX = offestX;
}
#pragma mark - collectionView 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
#define XMGPage 4

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return XMGPage;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XMGNewFeatureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[UICollectionViewCell alloc] init];
//    }
    cell.backgroundColor = [UIColor blueColor];
    
    // cell 创建出来就有imageview
    
    // 创建image
    // 拼接图片名字
    NSString *name = [NSString stringWithFormat:@"guide%ldBackground",indexPath.item + 1];
    
    UIImage *image = [UIImage imageNamed:name];
    cell.image = image;
    
//    NSLog(@"%@",cell);
    
    [cell setIndexPath:indexPath count:XMGPage];
    

//    self presentViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#> completion:<#^(void)completion#>
    
    return cell;
}
@end
