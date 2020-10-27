//
//  ShopCell.m
//  瀑布流
//
//  Created by yz on 15/11/25.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "ShopCell.h"

@interface ShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *lableView;



@end

@implementation ShopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    _lableView.text = [NSString stringWithFormat:@"%ld",indexPath.item];
}

@end
