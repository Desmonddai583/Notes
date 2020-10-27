//
//  FlagView.m
//  03-拦截用户输入
//
//  Created by xiaomage on 16/1/15.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "FlagView.h"
#import "FlagItem.h"

@interface FlagView()

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;

@end

@implementation FlagView


+ (instancetype)flagView{
    return  [[[NSBundle mainBundle] loadNibNamed:@"FlagView" owner:nil options:nil] lastObject];
}

-(void)setItem:(FlagItem *)item{
    _item = item;
    //给子控件赋值
    self.nameL.text = item.name;
    self.iconImageV.image = item.icon;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
