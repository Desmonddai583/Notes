//
//  XMGWineCell.m
//  01-购物车01-
//
//  Created by xiaomage on 16/1/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGWineCell.h"
#import "XMGWine.h"
#import "XMGCircleButton.h"

@interface XMGWineCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet XMGCircleButton *minusButton;

@end
@implementation XMGWineCell

- (void)setWine:(XMGWine *)wine
{
    _wine = wine;
    self.imageImageView.image = [UIImage imageNamed:wine.image];
    
    self.nameLabel.text = wine.name;
    
    self.moneyLabel.text = wine.money;
    
    // 根据count决定countLabel显示的文字
    self.countLabel.text = [NSString stringWithFormat:@"%d",wine.count];
    // 根据count决定减号按钮是否能点击
    self.minusButton.enabled = (wine.count > 0);
}

/**
 *  加号点击
 */
- (IBAction)plusButtonClick {
    // 1.修改模型
    self.wine.count ++ ;
    // 2.修改界面
    self.countLabel.text = [NSString stringWithFormat:@"%d",self.wine.count];
    // 3.减号按钮能点击
    self.minusButton.enabled = YES;

}

// kVO

/**
 *  减号点击
 */
- (IBAction)minusButtonClick {
    // 1.修改模型
    self.wine.count -- ;
    // 2.修改界面
    self.countLabel.text = [NSString stringWithFormat:@"%d",self.wine.count];
    
    if (self.wine.count == 0) {
        self.minusButton.enabled = NO;
    }
}
@end
