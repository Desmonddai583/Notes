//
//  PhotoCell.m
//  01-UICollectionView基本使用
//
//  Created by yz on 15/11/24.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;



@end

@implementation PhotoCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setImage:(UIImage *)image{
    _image = image;
    
    _iconView.image = image;
}
@end
