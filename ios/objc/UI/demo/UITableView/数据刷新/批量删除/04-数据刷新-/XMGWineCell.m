//
//  XMGWineCell.m
//  04-数据刷新-
//
//  Created by xiaomage on 16/1/11.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGWineCell.h"
#import "XMGWine.h"

@implementation XMGWineCell

- (void)setWine:(XMGWine *)wine
{
    _wine = wine;
    self.textLabel.text = wine.name;
    self.imageView.image = [UIImage imageNamed:wine.image];
    self.detailTextLabel.text = [NSString stringWithFormat:@"¥%@",wine.money];
}

@end
