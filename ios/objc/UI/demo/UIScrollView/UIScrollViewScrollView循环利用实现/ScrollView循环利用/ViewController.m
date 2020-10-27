//
//  ViewController.m
//  ScrollView循环利用
//
//  Created by 高新强 on 15/11/19.
//  Copyright © 2015年 Gavin. All rights reserved.
//

#import "ViewController.h"

#define kCount 8
@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) UIImageView *centerImageV;
@property (weak, nonatomic) UIImageView *reuseImageV;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    //图片的宽度
    CGFloat w = self.view.frame.size.width;
    //图片的高度
    CGFloat h = self.view.frame.size.height;
    
    //设置ScrollView初始化属性
    //设置分页效果
    self.scrollView.pagingEnabled = YES;
    //初始化ScollView的内容大小
    self.scrollView.contentSize = CGSizeMake(3 * w, h);
    //隐藏垂直滚动条
    self.scrollView.showsVerticalScrollIndicator = NO;
    //设置ScrollView代理
    self.scrollView.delegate = self;
    
    //创建一个可见的UIImageView(也就是中间的UIImageView)
    UIImageView *centerImageV = [[UIImageView alloc] init];
    //记录住中间的centerImageV.
    self.centerImageV = centerImageV;
    //设置一张默认图片
    self.centerImageV.image = [UIImage imageNamed:@"00"];
    //设置中间图片的x值为一个屏幕的宽度
    self.centerImageV.frame = CGRectMake(w, 0, w, h);
    //给图片绑定一个标识.
    self.centerImageV.tag = 0;
    //把图片添加到ScrollView上.
    [self.scrollView addSubview:self.centerImageV];
    
    
    
    //创建一个可重复利用的UIImageView,也就是一下滚动出来的图片.
    UIImageView *reuseImageV = [[UIImageView alloc] init];
    //记录住reuseImageV
    self.reuseImageV = reuseImageV;
    //把它的位置设置到最左侧.也就是0,0的位置,让它的大小和当前ScrollView的大小一样.
//    self.reuseImageV.image = [UIImage imageNamed:@"01"];
    self.reuseImageV.frame = self.view.bounds;
    
    //把图片添加到ScrollView上.
    [self.scrollView addSubview:self.reuseImageV];
    
    
    //初始化scrollView的偏移量.一开始显示中间部分.
    self.scrollView.contentOffset = CGPointMake(w, 0);

}

//当ScorllView滚动时调用.
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //获取ScrollView X轴方向的偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    //记录ScollView的宽度.
    CGFloat w = scrollView.frame.size.width;
    
    //设置循环利用View的位置.
    CGRect reuserImageVFrame = self.reuseImageV.frame;
    //记录当前是第几页
    NSInteger index = 0;
    
    //判断是向左滚动还是向右滚动
    if(offsetX > self.centerImageV.frame.origin.x){
        //如果是向右滚动
        //让重复利用的图片X在中间ImageView的后面.
        reuserImageVFrame.origin.x = CGRectGetMaxX(self.centerImageV.frame);
        //设置页数+1.
        index = self.centerImageV.tag + 1;
        if (index > kCount - 1) {
            //如果页数大于总个数.从第0页开始.
            index = 0;
        }
        
    }else{
        //如果是向左滚动.
        //设置重复利用的图片X在左侧,0的位置
        reuserImageVFrame.origin.x = 0;
        //设置页数-1
        index = self.centerImageV.tag - 1;
        //如果页数小于0页.
        if(index < 0){
            //从最后一页开始.
            index = kCount - 1;
        }
    }
    
    //设置重复利用的图片的位置
    self.reuseImageV.frame = reuserImageVFrame;
    //记录当前重复利用的图片是第几页
    _reuseImageV.tag = index;
    NSLog(@"%ld",index);
    //设置图片名称
    NSString *imageName = [NSString stringWithFormat:@"0%ld",index];
    //设置重复利用的图片
    self.reuseImageV.image = [UIImage imageNamed:imageName];
    
    //设置如果滚动到最左侧,或者滚动的最右侧.
    if(offsetX <= 0 || offsetX >= 2 * w){
        
        //交换中间的图片 和 重复利用图片两个对象.
        UIImageView *temp = self.centerImageV;
        self.centerImageV = self.reuseImageV;
        self.reuseImageV = temp;
        
        //交换两个图片的位置.
        self.centerImageV.frame = self.reuseImageV.frame;
        //初始化scrollView的偏移量.一开始显示中间部分.
        self.scrollView.contentOffset = CGPointMake(w, 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
